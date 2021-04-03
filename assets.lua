local anim8 = require 'vendor.anim8'

local assets = {
  tilesets = {
    dungeon = love.graphics.newImage("assets/dungeon_tiles.png"),
    dungeon_ii = love.graphics.newImage("assets/0x72_dungeon_tiles.png"),
  },
  cards = {
    hp = love.graphics.newImage('assets/sprites/cards/HP.PNG'),
    manastorm = love.graphics.newImage('assets/sprites/cards/mana_storm.PNG'),
    stoneskin = love.graphics.newImage('assets/sprites/cards/stoneskin.PNG'),
    chest = love.graphics.newImage('assets/sprites/cards/chest.PNG'),
  },
  items = {
    shard_blue = love.graphics.newImage('assets/sprites/kyrises/shard_01c.png'),
    shard_grey = love.graphics.newImage('assets/sprites/kyrises/shard_01e.png'),
  },
  fonts = {
    default = love.graphics.newFont('assets/fonts/GoldBox.ttf')
  },
  effects = {
    slash_white = love.graphics.newImage('assets/sprites/effects/slash-white/slash-white.png')
  }
}

local effect_slash_white_grid = anim8.newGrid(35, 32, assets.effects.slash_white:getWidth(), assets.effects.slash_white:getHeight())
local effect_slash_white = anim8.newAnimation(effect_slash_white_grid('1-5', 1), 0.1, 'pauseAtEnd'):flipH()

local animations = {
  effect = {
    slash_white = {
      image = assets.effects.slash_white,
      anim = effect_slash_white
    }
  }
}

assets.animations = animations

return assets