local anim8 = require("vendor.anim8")
local Inventory = require("inventory")
local Enemy = {}
Enemy.__index = Enemy

function Enemy.new (world, enemy_spawn)
  local enemy = {
    name = "Steve",
    health = 100,
    x = enemy_spawn.x,
    y = enemy_spawn.y,
    size = 16,
    speed = 128,
    sprint_speed = 200,
    sprinting = false,
    inventory = Inventory.new(),
    world = world,
    physics = {},
    collision_x_limit = nil,
    collision_y_limit = nil,
    is_active = true,
    animations = {},
    current_direction = 'right',
    current_anim = 'idle',
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
  player:setHealth(-10)
end

function Enemy:update (dt)
  self.sprinting = true
  local speed = (self.sprinting and self.sprint_speed or self.speed)
  local x_vel = math.random(-1, 1) * speed
  local y_vel = math.random(-1, 1) * speed
  -- TODO: Get goal destination and try to get there
  -- if (controls:isActionDown("RIGHT")) then
  --   x_vel = x_vel + speed
  -- end
  -- if (controls:isActionDown("LEFT")) then
  --   x_vel = x_vel + -speed
  -- end
  -- if (controls:isActionDown("UP")) then
  --   y_vel = y_vel + -speed
  -- end
  -- if (controls:isActionDown("DOWN")) then
  --   y_vel = y_vel + speed
  -- end
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

function Enemy:draw ()
  love.graphics.setColor(255, 255, 255, 1)
  local direction_modifier = self.current_direction == 'right' and 1 or -1
  self.animations[self.current_anim].anim:draw(self.animations[self.current_anim].sprites, self.x, self.y, 0, direction_modifier, 1, self.size / 2, self.size / 2)
end

return Enemy