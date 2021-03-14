local controls = require "controls".get("player")
local Inventory = require("inventory")
local Player = {}
Player.__index = Player

function Player.new (world, player_spawn)
  local player = {
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
    sprite = love.graphics.newImage("assets/sprites/knight.png"),
    is_active = true
  }
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

function Player:handlePickup (item)
  if (item.item_type == "heal_potion") then
    self.health = math.min(self.health + 20, 100)
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
  self.physics.body:setLinearVelocity(x_vel, y_vel)
  if (controls:isActionDown("INTERACT")) then
    self.health = math.max(self.health - 1, 0)
  end
  self.x = self.physics.body:getX();
  self.y = self.physics.body:getY();
end

function Player:draw ()
  love.graphics.draw(self.sprite, math.floor(self.x), math.floor(self.y), 0, 1, 1, self.size / 2, self.size / 2)
end

return Player