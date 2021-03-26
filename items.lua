local anim8 = require "vendor.anim8"
local assets = require "assets"
local cards = require "cards"

local tile_set_img = assets.tilesets.dungeon
local tile_set_grid = anim8.newGrid(GRID_SIZE, GRID_SIZE, tile_set_img:getWidth(), tile_set_img:getHeight())

local items = {
  heal_potion = {
    quad = tile_set_grid(8, 1)[1],
    card = cards.hp,
    onPickup = function (player)
      -- Do something
    end
  },
  key = {
    quad = tile_set_grid(6, 1)[1],
    card = cards.chest,
    onPickup = function (player)
      -- Do something
    end
  }
}

return items
