require("vendor.shadows")
local LightWorld = require("vendor.shadows.LightWorld")
local gamera = require "vendor.gamera"
local sti = require "vendor.sti"
local Grid = require "vendor.jumper.grid"
local Pathfinder = require "vendor.jumper.pathfinder"
local Player = require "player"
local InteractiveEntity = require "interactive_entity"
local LootableContainer = require "lootable_container"
local Enemy = require "enemy"
local Level = {}
Level.__index = Level

function Level.new(world_path)
  local level = {
    player_spawn = {x = 0, y = 0},
    walkable_value = 1,
    world_path = world_path
  }
  setmetatable(level, Level)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  level:setupPhysicsWorld()
  level:setupTileMap()
  level:generateCollisionMap()
  level:setupCamera()
  level:getPlayerSpawn()
  level.lights = LightWorld:new()
  level.player = Player.new(level, level.player_spawn)
  level:processTileMap()
  -- TODO: This doesn't seem to scale right
  -- level.lights:InitFromPhysics(level.world)
  table.insert(level.spriteLayer.sprites, level.player)
  return level
end

function Level.handleCollision (a, b, coll)
  local a_data = a:getUserData()
  local b_data = b:getUserData()
  if (a_data and a_data.is_player and a_data.is_active and b_data) then
    if (b_data.handleCollidePlayer and b_data.is_active) then
      b_data:handleCollidePlayer(a_data)
    elseif (b_data.onPickup and b_data.is_active) then
      b_data:onPickup(a_data)
    end
  end
end

function Level:getPlayerSpawn ()
  if (self.player_spawn.x ~= 0 or self.player_spawn.y ~= 0) then
    return self.player_spawn
  end
  local gameObjects = self.map.layers['GameObjects']
  self.player_spawn = {x = 0, y = 0}
  for _, object in pairs(gameObjects.objects) do
    if (object.properties.object_type == 'player_spawn') then
      self.player_spawn.x = object.x
      self.player_spawn.y = object.y
      break
    end
  end
end

function Level:generateCollisionMap()
  self.collision_map = {}
  for y = 1, self.map.height do
    self.collision_map[y] = {}
    for x = 1, self.map.width do
      self.collision_map[y][x] = self.map.layers['Floor'].data[y][x] and self.walkable_value or 0
    end
  end
end

function Level:generatePathfinder()
  local jumper_grid = Grid(self.collision_map)
  local finder = Pathfinder(jumper_grid, 'JPS', self.walkable_value)
  self.pathfinder = finder
end

function Level:setupCamera()
  local w, h = self.map.tilewidth * self.map.width, self.map.tileheight * self.map.height
  self.camera = gamera.new(0, 0, w, h)
  self.camera:setScale(CANVAS_SCALE)
end

function Level:setupPhysicsWorld()
  love.physics.setMeter(GRID_SIZE)
  self.world = love.physics.newWorld(0, 0)
  self.world:setCallbacks(Level.handleCollision)
end

function Level:setupTileMap()
  self.map = sti(self.world_path, {'box2d'})
  self.map:box2d_init(self.world)
end

function Level:processTileMap()
  self:extractTileMapTileSets()
  self:attachSpriteLayer()
  self:placeWorldEdges()
  self:generatePathfinder()
  self:processGameObjects()
end

function Level:extractTileMapTileSets()
  self.map_tilesets_by_name = {}
  for _, set in pairs(self.map.tilesets) do
    self.map_tilesets_by_name[set.name] = set
  end
end

function Level:attachSpriteLayer()
  self.map:addCustomLayer('Sprites', 6) -- Dungeon = 6, dungeon_ii = 3
  self.spriteLayer = self.map.layers['Sprites']
  self.spriteLayer.sprites = {}
  function self.spriteLayer:update(dt)
    for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:update(dt)
      end
    end
    table.sort(self.sprites, function (a, b)
      return (a.y + GRID_SIZE) < b.y
    end)
  end
  function self.spriteLayer:draw()
    for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:draw()
      end
    end
  end
end

function Level:placeWorldEdges()
  for y, row in pairs(self.collision_map) do
    for x, tile in pairs(row) do
      local up = (self.collision_map[y - 1] or {})[x] or 0
      local down = (self.collision_map[y + 1] or {})[x] or 0
      local left = self.collision_map[y][x - 1] or 0
      local right = self.collision_map[y][x + 1] or 0
      if (tile == 0 and (up + down + left + right > 0)) then
        local body = love.physics.newBody(self.world, (x - 1) * GRID_SIZE, (y - 1) * GRID_SIZE, 'static')
        local shape = love.physics.newRectangleShape((GRID_SIZE / 2), (GRID_SIZE / 2), GRID_SIZE, GRID_SIZE)
        love.physics.newFixture(body, shape)
        body:setFixedRotation(true)
      end
    end
  end
end

function Level:processGameObjects()
  self:processLayerGameObjects('GameObjects')
  self:processLayerGameObjects('PersistentGameObjects')
end

function Level:processLayerGameObjects(layer)
  local gameObjects = self.map.layers[layer]
  if (gameObjects ~= nil) then
    for _, object in pairs(gameObjects.objects) do
      if object.properties.object_type ~= nil and object.properties.object_type == 'enemy_spawn' then
        table.insert(self.spriteLayer.sprites, Enemy.new(self, {x = object.x, y = object.y}))
      elseif object.properties.lootable then
          table.insert(self.spriteLayer.sprites,
            LootableContainer.new(self, object.x, object.y, self.map.tilesets[self.map.tiles[object.gid].tileset].image, self.map.tiles[object.gid].quad))
      elseif object.properties.object_type ~= nil and object.properties.object_type ~= 'player_spawn' then
        table.insert(self.spriteLayer.sprites,
          InteractiveEntity.new(self, object.x, object.y, object.properties.object_type, object.properties.item_type,
            self.map.tilesets[self.map.tiles[object.gid].tileset].image, self.map.tiles[object.gid].quad))
      end
    end
    self.map:removeLayer(layer)
  end
end

return Level
