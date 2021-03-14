local anim8 = require("vendor.anim8")
local controls = require "controls".get("player")
local Inventory = require("inventory")
local Player = {}
Player.__index = Player

function Player.new (world, player_spawn)
  local player = {
    name = "Player",
    is_player = true,
    health = 100,
    x = player_spawn.x,
    y = player_spawn.y,
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
    is_dead = false
  }
  local idle_spritesheet = love.graphics.newImage('assets/spritesheets/knight_idle_spritesheet.png')
  local idle_grid = anim8.newGrid(16, 16, idle_spritesheet:getWidth(), idle_spritesheet:getHeight())
  local idle_animation = anim8.newAnimation(idle_grid('1-6', 1), 0.2)
  player.animations.idle = {anim = idle_animation, sprites = idle_spritesheet}
  local run_spritesheet = love.graphics.newImage('assets/spritesheets/knight_run_spritesheet.png')
  local run_grid = anim8.newGrid(16, 16, run_spritesheet:getWidth(), run_spritesheet:getHeight())
  local run_animation = anim8.newAnimation(run_grid('1-6', 1), 0.2)
  player.animations.run = {anim = run_animation, sprites = run_spritesheet}
  setmetatable(player, Player)
  player.physics.body = love.physics.newBody(world, player.x, player.y, "dynamic")
  player.physics.shape = love.physics.newRectangleShape(0, player.size / 4, player.size,player.size / 2)
  player.physics.fixture = love.physics.newFixture(player.physics.body, player.physics.shape)
  player.physics.body:setFixedRotation(true)
  player.physics.fixture:setUserData(player)
  controls:addAction("ESCAPE", function ()
    love.event.quit()
  end)
  return player
end

function Player:setHealth(modifier)
  self.health = math.max(math.min(self.health + modifier, 100), 0)
  if (self.health == 0) then
    self.is_dead = true
    self.is_active = false
  end
end

function Player:handlePickup (item)
  if (item.item_type == "heal_potion") then
    self:setHealth(20)
  end
end

function Player:update (dt)
  self.sprinting = controls:isActionDown("SPRINT")
  local speed = (self.sprinting and self.sprint_speed or self.speed)
  local x_vel = 0
  local y_vel = 0
  if (controls:isActionDown("RIGHT")) then
    x_vel = x_vel + speed
  end
  if (controls:isActionDown("LEFT")) then
    x_vel = x_vel + -speed
  end
  if (controls:isActionDown("UP")) then
    y_vel = y_vel + -speed
  end
  if (controls:isActionDown("DOWN")) then
    y_vel = y_vel + speed
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
  if (controls:isActionDown("INTERACT")) then
    self:setHealth(-1)
  end
  self.x = self.physics.body:getX();
  self.y = self.physics.body:getY();
  self.animations[self.current_anim].anim:update(dt)
end

function Player:draw ()
  local direction_modifier = self.current_direction == 'right' and 1 or -1
  self.animations[self.current_anim].anim:draw(self.animations[self.current_anim].sprites, self.x, self.y, 0, direction_modifier, 1, self.size / 2, self.size / 2)
end

return Player