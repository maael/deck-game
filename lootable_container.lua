local InteractiveEntity = require 'interactive_entity'
local LootableContainer = {}
LootableContainer.__index = LootableContainer

function LootableContainer.new(world, x, y, tile_set_img, tile_set_grid, spritesLayer)
  local lootable_container = {
    world = world,
    is_lootable = true,
    is_looted = false,
    x = x,
    y = y,
    size = GRID_SIZE,
    physics = {},
    spritesLayer = spritesLayer,
    tile_set_img = tile_set_img,
    tile_set_grid = tile_set_grid,
  }
  setmetatable(lootable_container, LootableContainer)
  lootable_container.physics.body = love.physics.newBody(world, lootable_container.x + (GRID_SIZE / 2),
    lootable_container.y + (GRID_SIZE / 2), 'static')
  lootable_container.physics.shape = love.physics.newRectangleShape(0, 0, lootable_container.size,
    lootable_container.size)
  lootable_container.physics.fixture = love.physics.newFixture(lootable_container.physics.body,
    lootable_container.physics.shape)
  lootable_container.physics.body:setFixedRotation(true)
  lootable_container.physics.fixture:setSensor(true)
  lootable_container.physics.fixture:setUserData(lootable_container)
  return lootable_container
end

function LootableContainer:handleLoot(player)
  if not self.is_looted then
    self.is_looted = true
    table.insert(self.spritesLayer,
      InteractiveEntity.new(self.world, self.x, self.y + GRID_SIZE, 'pickup_item', 'heal_potion', self.tile_set_img,
        self.tile_set_grid))
  end
end

function LootableContainer:update(dt)
end

function LootableContainer:draw()
end

return LootableContainer
