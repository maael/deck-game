local anim8 = require('vendor.anim8')
local serialize = require('vendor.ser')
local Inventory = require('inventory')
local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(level, enemy_spawn)
  local enemy = {
    name = 'Steve',
    health = 100,
    x = enemy_spawn.x,
    y = enemy_spawn.y,
    size = GRID_SIZE,
    speed = 25,
    sprint_speed = 50,
    sprinting = false,
    inventory = Inventory.new(),
    world = level.world,
    physics = {},
    collision_x_limit = nil,
    collision_y_limit = nil,
    is_active = true,
    debug = DEBUG_ENEMIES,
    animations = {},
    current_direction = 'right',
    current_anim = 'idle',
    player = level.player,
    vision_range = 100,
    intersect_x = nil,
    intersect_y = nil,
    can_see_player = false,
    player_normal_x = nil,
    player_normal_y = nil,
    collision_map = level.collision_map,
    pathfinder = level.pathfinder,
    path = nil,
    goal = nil,
    map = level.map
  }
  local idle_spritesheet = love.graphics.newImage('assets/spritesheets/goblin_idle_spritesheet.png')
  local idle_grid = anim8.newGrid(GRID_SIZE, GRID_SIZE, idle_spritesheet:getWidth(), idle_spritesheet:getHeight())
  local idle_animation = anim8.newAnimation(idle_grid('1-6', 1), 0.2)
  enemy.animations.idle = {anim = idle_animation, sprites = idle_spritesheet}
  local run_spritesheet = love.graphics.newImage('assets/spritesheets/goblin_run_spritesheet.png')
  local run_grid = anim8.newGrid(GRID_SIZE, GRID_SIZE, run_spritesheet:getWidth(), run_spritesheet:getHeight())
  local run_animation = anim8.newAnimation(run_grid('1-6', 1), 0.2)
  enemy.animations.run = {anim = run_animation, sprites = run_spritesheet}
  setmetatable(enemy, Enemy)
  enemy.physics.body = love.physics.newBody(level.world, enemy.x, enemy.y, 'dynamic')
  enemy.physics.shape = love.physics.newRectangleShape(0, enemy.size / 4, enemy.size, enemy.size / 2)
  enemy.physics.fixture = love.physics.newFixture(enemy.physics.body, enemy.physics.shape)
  enemy.physics.body:setFixedRotation(true)
  enemy.physics.fixture:setUserData(enemy)
  return enemy
end

function Enemy:handleCollidePlayer(player)
  player:setHealth(-1)
end

function Enemy:update(dt)
  self.sprinting = true
  local speed = (self.sprinting and self.sprint_speed or self.speed)
  self:checkPlayerVisibility()
  local x_vel = 0
  local y_vel = 0

  local contacts = self.physics.body:getContacts()

  for _, contact in pairs(contacts) do
    local a, b = contact:getFixtures()
    local a_data = a:getUserData()
    if (a_data and a_data.is_player) then
      self:handleCollidePlayer(a_data)
    end
  end

  local current_x, current_y = self.map:convertPixelToTile(self.x, self.y)
  local rounded_current_x, rounded_current_y = math.floor(current_x), math.floor(current_y)

  if (self.goal) then
    local initial_goal_x, initial_goal_y = self.map:convertPixelToTile(self.goal.x, self.goal.y)
    if (rounded_current_x == math.floor(initial_goal_x) and rounded_current_y == math.floor(initial_goal_y)) then
      self.path = nil
      self.goal = nil
    end
  end

  if (self.can_see_player) then
    self.goal = {x = self.player.x, y = self.player.y}
    self.path = nil
  elseif (self.goal == nil or self.path == nil) then
    self.goal = nil
    while (self.goal == nil) do
      local potential_x = math.random(#self.collision_map[1])
      local potential_y = math.random(#self.collision_map)
      local is_walkable = self.collision_map[potential_y][potential_x]
      if (is_walkable == 1) then
        local potential_pixel_x, potential_pixel_y = self.map:convertTileToPixel(potential_x - 1, potential_y - 1)
        self.goal = {x = potential_pixel_x, y = potential_pixel_y}
      end
    end
  end

  -- Get path is missing one path
  if (self.path == nil and self.goal ~= nil) then
    local goal_x, goal_y = self.map:convertPixelToTile(self.goal.x, self.goal.y)
    local path = self.pathfinder:getPath(rounded_current_x, rounded_current_y, math.floor(goal_x), math.floor(goal_y))
    if (path) then
      self.path = {}
      for node in path:nodes() do
        table.insert(self.path, {x = node:getX() - 1, y = node:getY() - 1})
      end
    else
      self.path = nil
      self.goal = nil
    end
  end

  if (self.path and self.path[2] and rounded_current_x == self.path[2].x and rounded_current_y == self.path[2].y) then
    table.remove(self.path, 2)
  end

  local normalised_x = 0
  local normalised_y = 0
  if (self.path and self.path[2]) then
    local path_pix_x, path_pix_y = self.map:convertTileToPixel(self.path[2].x, self.path[2].y)
    local diff_x = math.floor(self.x - (path_pix_x + (GRID_SIZE / 2)))
    local diff_y = math.floor(self.y - (path_pix_y + (GRID_SIZE / 2)))
    normalised_x = diff_x < 0 and 1 or diff_x == 0 and 0 or -1
    normalised_y = diff_y < 0 and 1 or diff_y == 0 and 0 or -1
  elseif (self.can_see_player) then
    local diff_x = self.x - self.player.x
    local diff_y = self.y - self.player.y
    normalised_x = diff_x < 0 and 1 or diff_x == 0 and 0 or -1
    normalised_y = diff_y < 0 and 1 or diff_y == 0 and 0 or -1
  else
    self.path = nil
  end

  x_vel = normalised_x * speed
  y_vel = normalised_y * speed

  if (x_vel ~= 0 or y_vel ~= 0) then
    if (x_vel > 0) then
      self.current_direction = 'right'
    elseif (x_vel < 0) then
      self.current_direction = 'left'
    end
    self.current_anim = 'run'
  else
    self.current_anim = 'idle'
  end
  self.physics.body:setLinearVelocity(x_vel, y_vel)
  self.x = self.physics.body:getX();
  self.y = self.physics.body:getY();
  self.animations[self.current_anim].anim:update(dt)
end

function Enemy:checkPlayerVisibility()
  self.can_see_player = false
  self.intersect_x = nil
  self.intersect_y = nil
  self.player_normal_x = nil
  self.player_normal_y = nil
  local distance = math.abs(math.sqrt(((self.player.x - self.x) ^ 2) + ((self.player.y - self.y) ^ 2)))
  if (distance <= self.vision_range) then
    local visible_hits = {}
    -- Get all fixtures between us and player
    self.world:rayCast(self.x, self.y, self.player.x, self.player.y, function(fixture, x, y, xn, yn, fr)
      table.insert(visible_hits, {fr = fr, data = fixture:getUserData(), x = x, y = y, xn = xn, yn = yn})
      return fr
    end)
    -- Get the closest hit
    local closest
    for _, item in pairs(visible_hits) do
      if (not closest or closest.fr > item.fr) then
        closest = item
      end
    end
    -- Set intersection point if active, and include if it's the player or not
    if (closest and closest.data and closest.data.is_active) then
      self.can_see_player = closest.data.is_player
      self.player_normal_x = closest.xn
      self.player_normal_y = closest.yn
      self.intersect_x = closest.x
      self.intersect_y = closest.y
    end
  end
  if (self.can_see_player) then
    return self.intersect_x, self.intersect_y
  end
end

function Enemy:draw()
  love.graphics.push()
  love.graphics.setColor(255, 255, 255, 1)
  local direction_modifier = self.current_direction == 'right' and 1 or -1
  self.animations[self.current_anim].anim:draw(self.animations[self.current_anim].sprites, self.x, self.y, 0,
    direction_modifier, 1, self.size / 2, self.size / 2)

  if (self.debug) then
    love.graphics.setLineWidth(2)
    love.graphics.setColor(255, 0, 0, 1)
    if (self.can_see_player) then
      love.graphics.setColor(0, 255, 0, 1)
    end
    if (self.intersect_x and self.intersect_y) then
      love.graphics.line(self.x, self.y, self.intersect_x, self.intersect_y)
    end
    love.graphics.setColor(255, 0, 0, 1);
    love.graphics.polygon('line', self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
    if (self.path) then
      for i, node in pairs(self.path) do
        if (i == 1) then
          love.graphics.setColor(0, 0, 255, 0.5);
        else
          love.graphics.setColor(0, 255, 0, 0.5);
        end
        love.graphics.rectangle("fill", node.x * GRID_SIZE, node.y * GRID_SIZE, GRID_SIZE, GRID_SIZE)
      end
    end
  end
  love.graphics.pop()
end

return Enemy
