require 'globals'
local sti = require 'vendor/sti'
local gamera = require ("vendor/gamera")
local fpsGraph = require 'vendor/FPSGraph'
local Grid = require ("vendor/jumper.grid")
local Pathfinder = require ("vendor/jumper.pathfinder")
local controls = require'controls'.get('player')
local HUD = require 'hud'
local Player = require 'player'
local PlayerMenu = require 'player_menu'
local Enemy = require 'enemy'
local InteractiveEntity = require 'interactive_entity'
local LootableContainer = require 'lootable_container'

local player
local hud
local camera
local graph
local player_menu

function BeginContact(a, b, coll)
  local a_data = a:getUserData()
  local b_data = b:getUserData()
  if (a_data.is_player and a_data.is_active) then
    if (b_data.handleCollidePlayer and b_data.is_active) then
      b_data:handleCollidePlayer(a_data)
    elseif (b_data.onPickup and b_data.is_active) then
      b_data:onPickup(a_data)
    end
  end
end

function love.load()
  graph = fpsGraph.createGraph(10, 50, 50, 30, 0.5, false)

  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.physics.setMeter(GRID_SIZE)
  world = love.physics.newWorld(0, 0)
  world:setCallbacks(BeginContact)
  map = sti('assets/dungeon.lua', {'box2d'})
  map:box2d_init(world)

  local w, h = map.tilewidth * map.width, map.tileheight * map.height
  camera = gamera.new(0, 0, w, h)
  camera:setScale(CANVAS_SCALE)

  -- Find player spawn point
  local gameObjects = map.layers['GameObjects']
  local player_spawn = {x = 0, y = 0}

  for _, object in pairs(gameObjects.objects) do
    if (object.properties.object_type == 'player_spawn') then
      player_spawn.x = object.x
      player_spawn.y = object.y
    end
  end

  player = Player.new(world, player_spawn, map)
  player_menu = PlayerMenu.new(player)
  hud = HUD.new(player)

  -- Create collision map for path finding
  -- TODO: Seems to be off by one or something
  local collision_map = {}
  local walkable = 1
  for y = 1, map.height do
    collision_map[y] = {}
    for x = 1, map.width do
      collision_map[y][x] = map.layers['Floor'].data[y][x] and walkable or 0
    end
  end
  local jumper_grid = Grid(collision_map)
  local finder = Pathfinder(jumper_grid, 'JPS', walkable)

  -- Add Player to custom layer in map
  -- This is the secret sauce that makes collisions work properly
  map:addCustomLayer('Sprites', 7)
  local spriteLayer = map.layers['Sprites']
  spriteLayer.sprites = {player}
  function spriteLayer:update(dt)
    for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:update(dt)
      end
    end
    table.sort(self.sprites, function (a, b)
      return (a.y + GRID_SIZE) < b.y
    end)
  end
  function spriteLayer:draw()
    for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:draw()
      end
    end
  end

  local map_tilesets_by_name = {}
  for _, set in pairs(map.tilesets) do
    map_tilesets_by_name[set.name] = set
  end

  -- Process game objects
  local gameObjects = map.layers['GameObjects']
  for _, object in pairs(gameObjects.objects) do
    if object.properties.object_type ~= nil and object.properties.object_type == 'enemy_spawn' then
      table.insert(spriteLayer.sprites, Enemy.new(world, {x = object.x, y = object.y}, player, map, collision_map, finder))
    elseif object.properties.object_type ~= nil and object.properties.object_type ~= 'player_spawn' then
      table.insert(spriteLayer.sprites,
        InteractiveEntity.new(world, object.x, object.y, object.properties.object_type, object.properties.item_type,
          map.tilesets[map.tiles[object.gid].tileset].image, map.tiles[object.gid].quad))
    end
  end
  map:removeLayer('GameObjects')
  local persistentGameObjects = map.layers['PersistentGameObjects']
  for _, object in pairs(persistentGameObjects.objects) do
    if object.properties.lootable then
      table.insert(spriteLayer.sprites,
        LootableContainer.new(world, object.x, object.y, map.tilesets[map.tiles[object.gid].tileset].image, map.tiles[object.gid].quad, map_tilesets_by_name, spriteLayer.sprites))
    else
      table.insert(spriteLayer.sprites,
        InteractiveEntity.new(world, object.x, object.y, object.properties.object_type, object.properties.item_type,
          map.tilesets[map.tiles[object.gid].tileset].image, map.tiles[object.gid].quad))
    end
  end
  map:removeLayer('PersistentGameObjects')
end

function love.keypressed(key)
  controls:handlePressed('keyboard', key)
  player_menu.controls:handlePressed('keyboard', key)
end

function love.gamepadpressed(key)
  controls:handlePressed('gamepad', key)
  player_menu.controls:handlePressed('gamepad', key)
end

function love.update(dt)
  love.window.setTitle('DeckGame v0.0.1 (FPS: ' .. love.timer.getFPS() .. ')')
  player_menu:update(dt)
  player_menu.controls:update(dt)
  if (not player_menu.is_open) then
    world:update(dt)
    map:update(dt)
    controls:update(dt)
    camera:setPosition(player.x, player.y)
  end
  fpsGraph.updateFPS(graph, dt)
end

function love.draw()
  love.graphics.setColor({255, 255, 255, 1})
  camera:draw(function(l, t, w, h)
    map:draw(-l, -t, CANVAS_SCALE, CANVAS_SCALE)
  end)
  player_menu:draw()
  if (player.is_dead) then
    hud:drawDeathScreen()
  end
  hud:draw()
  fpsGraph.drawGraphs({graph})
end
