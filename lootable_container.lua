local Shadows = require("vendor.shadows")
local LightWorld = require("vendor.shadows.LightWorld")
local Light = require("shadows.Light")
local Body = require("shadows.Body")
local InteractiveEntity = require 'interactive_entity'
local items = require "items"
local LootableContainer = {}
LootableContainer.__index = LootableContainer

function LootableContainer.new(level, x, y, tile_set_img, tile_set_quad)
  local lootable_container = {
    level = level,
    is_lootable = true,
    is_looted = false,
    x = x,
    y = y - GRID_SIZE,
    size = GRID_SIZE,
    physics = {},
    tile_set_img = tile_set_img,
    tile_set_quad = tile_set_quad,
    is_active = true,
    debug = DEBUG_GAME_OBJECTS,
  }
  lootable_container.light = Light:new(level.lights, 100)
  lootable_container.light:SetColor(218,165,32)
  setmetatable(lootable_container, LootableContainer)
  lootable_container.physics.body = love.physics.newBody(level.world, lootable_container.x + (GRID_SIZE / 2),
    lootable_container.y + (0.75 * GRID_SIZE), 'static')
  lootable_container.physics.shape = love.physics.newRectangleShape(0, 0, lootable_container.size,
    lootable_container.size / 2)
  lootable_container.physics.fixture = love.physics.newFixture(lootable_container.physics.body,
    lootable_container.physics.shape)
  lootable_container.physics.body:setFixedRotation(true)
  lootable_container.physics.fixture:setUserData(lootable_container)
  return lootable_container
end

function LootableContainer:handleLoot(player)
  if not self.is_looted then
    self.is_looted = true
    table.insert(self.level.spriteLayer.sprites,
      InteractiveEntity.new(self.level, self.x, self.y + (GRID_SIZE * 2), 'pickup_item', 'heal_potion', self.level.map_tilesets_by_name['Dungeon Crawler'].image,
        items.heal_potion.quad))
  end
end

function LootableContainer:update(dt)
  if (not self.is_looted) then
    self.light:SetPosition(self.level.camera:toScreen(self.x + (GRID_SIZE / 2), self.y + (GRID_SIZE / 2)))
  elseif (self.light) then
    self.light:Remove()
    self.light = nil
  end
end

function LootableContainer:draw()
  love.graphics.push()
  love.graphics.setColor({255, 255, 255, 1})
  love.graphics.draw(self.tile_set_img, self.tile_set_quad, self.x, self.y)
  if (self.debug) then
    love.graphics.setColor({255, 0, 0, 0.5})
    love.graphics.polygon("fill", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
  end
  love.graphics.pop()
end

return LootableContainer
