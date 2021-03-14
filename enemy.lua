local anim8 = require("vendor.anim8")
local Inventory = require("inventory")
local player = require "player"
local Enemy = {}
Enemy.__index = Enemy

function Enemy.new (world, enemy_spawn, player)
  local enemy = {
    name = "Steve",
    health = 100,
    x = enemy_spawn.x,
    y = enemy_spawn.y,
    size = 16,
    speed = 50,
    sprint_speed = 100,
    sprinting = false,
    inventory = Inventory.new(),
    world = world,
    physics = {},
    collision_x_limit = nil,
    collision_y_limit = nil,
    is_active = true,
    debug = false,
    animations = {},
    current_direction = 'right',
    current_anim = 'idle',
    player = player,
    vision_range = 100,
    intersect_x = nil,
    intersect_y = nil,
    can_see_player = false,
    player_normal_x = nil,
    player_normal_y = nil
  }
  local idle_spritesheet = love.graphics.newImage('assets/spritesheets/goblin_idle_spritesheet.png')
  local idle_grid = anim8.newGrid(16, 16, idle_spritesheet:getWidth(), idle_spritesheet:getHeight())
  local idle_animation = anim8.newAnimation(idle_grid('1-6', 1), 0.2)
  enemy.animations.idle = {anim = idle_animation, sprites = idle_spritesheet}
  local run_spritesheet = love.graphics.newImage('assets/spritesheets/goblin_run_spritesheet.png')
  local run_grid = anim8.newGrid(16, 16, run_spritesheet:getWidth(), run_spritesheet:getHeight())
  local run_animation = anim8.newAnimation(run_grid('1-6', 1), 0.2)
  enemy.animations.run = {anim = run_animation, sprites = run_spritesheet}
  setmetatable(enemy, Enemy)
  enemy.physics.body = love.physics.newBody(world, enemy.x, enemy.y, "dynamic")
  enemy.physics.shape = love.physics.newRectangleShape(0, enemy.size / 4, enemy.size,enemy.size / 2)
  enemy.physics.fixture = love.physics.newFixture(enemy.physics.body, enemy.physics.shape)
  enemy.physics.body:setFixedRotation(true)
  enemy.physics.fixture:setUserData(enemy)
  return enemy
end

function Enemy:handlePickup (item)
  if (item.item_type == "heal_potion") then
    self.health = math.min(self.health + 20, 100)
  end
end

function Enemy:handleCollidePlayer (player)
  -- TODO: Doesn't seem to trigger consistently when the enemy is hunting us
  player:setHealth(-10)
end

function Enemy:update (dt)
  self.sprinting = true
  local speed = (self.sprinting and self.sprint_speed or self.speed)
  self:checkPlayerVisibility()
  local x_vel = 0
  local y_vel = 0

  if (self.can_see_player) then
    -- TODO: Using the player_normal values seems whack
    -- TODO: Should commute direction for forces from
    -- TODO: our position and player position directly
    if (self.player_normal_x == -1) then
      x_vel = x_vel + speed
    end
    if (self.player_normal_x == 1) then
      x_vel = x_vel + -speed
    end
    if (self.player_normal_y == 1) then
      y_vel = y_vel + -speed
    end
    if (self.player_normal_y == -1) then
      y_vel = y_vel + speed
    end
  else
    -- TODO: Get goal destination and try to get there when no player
    x_vel = math.random(-1, 1) * speed
    y_vel = math.random(-1, 1) * speed
  end
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

function Enemy:checkPlayerVisibility ()
  self.can_see_player = false
  self.intersect_x = nil
  self.intersect_y = nil
  self.player_normal_x = nil
  self.player_normal_y = nil
  local distance = math.abs(math.sqrt(((self.player.x - self.x) ^ 2) + ((self.player.y - self.y) ^ 2)))
  if (distance <= self.vision_range) then
    local visible_hits = {}
    -- Get all fixtures between us and player
    self.world:rayCast(self.x, self.y, self.player.x, self.player.y, function (fixture, x, y, xn, yn, fr)
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
    if (closest and closest.data.is_active) then
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

function Enemy:draw ()
  love.graphics.setColor(255, 255, 255, 1)
  local direction_modifier = self.current_direction == 'right' and 1 or -1
  self.animations[self.current_anim].anim:draw(self.animations[self.current_anim].sprites, self.x, self.y, 0, direction_modifier, 1, self.size / 2, self.size / 2)

  if (self.debug) then
    love.graphics.setLineWidth(2)
    love.graphics.setColor(255, 0, 0, 1)
    if (self.can_see_player) then
      love.graphics.setColor(0, 255, 0, 1)
    end
    if (self.intersect_x and self.intersect_y) then
      love.graphics.line(self.x, self.y, self.intersect_x, self.intersect_y)
    end
  end
end

return Enemy