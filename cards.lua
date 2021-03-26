local assets = require "assets"

local cards = {
  hp = {
    img = assets.cards.hp,
    onPlay = function (player)
      player:setHealth(20)
    end,
    mana = 3
  },
  chest = {
    img = assets.cards.chest,
    mana = 1
  },
  manastorm = {
    img = assets.cards.manastorm,
    mana = 2
  }
}

return cards