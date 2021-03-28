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
  }
}

return assets