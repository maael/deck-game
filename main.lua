require 'globals'
local sti = require 'vendor/sti'
local anim8 = require 'vendor/anim8'
local Camera = require 'vendor/STALKER-X/camera'
local fpsGraph = require 'vendor/FPSGraph'
local controls = require'controls'.get('player')
local HUD = require 'hud'
local Player = require 'player'
local PlayerMenu = require 'player_menu'
local Enemy = require 'enemy'
local InteractiveEntity = require 'interactive_entity'
local LootableContainer = require 'lootable_container'
local assets = require "assets"

local player
local hud
local camera
local canvas
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

  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
  camera = Camera(CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2, CANVAS_WIDTH, CANVAS_HEIGHT)
  camera:setBounds(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
  camera:setFollowStyle('TOPDOWN_TIGHT')
  camera:setFollowLerp(0.1)

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
  end
  function spriteLayer:draw()
    table.sort(self.sprites, function (a, b)
      return (a.y + GRID_SIZE) < b.y
    end)
    for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:draw()
      end
    end
  end

  -- Process game objects
  local gameObjects = map.layers['GameObjects']
  for _, object in pairs(gameObjects.objects) do
    if object.properties.object_type ~= nil and object.properties.object_type == 'enemy_spawn' then
      table.insert(spriteLayer.sprites, Enemy.new(world, {x = object.x, y = object.y}, player))
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
        LootableContainer.new(world, object.x, object.y, map.tilesets[map.tiles[object.gid].tileset].image, map.tiles[object.gid].quad, spriteLayer.sprites))
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
    camera:update(dt)
    camera:follow(player.x, player.y)
  end
  fpsGraph.updateFPS(graph, dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  camera:attach()
  love.graphics.setColor({255, 255, 255, 1})
  map:draw(math.floor(-camera.x + CANVAS_WIDTH / 2), math.floor(-camera.y + CANVAS_HEIGHT / 2))
  player_menu:draw()
  -- love.graphics.setColor({255, 0, 0, 1})
  -- map:box2d_draw()
  -- love.graphics.setColor({255, 255, 255, 1})
  camera:detach()
  camera:draw()
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, CANVAS_SCALE, CANVAS_SCALE)
  love.graphics.setBlendMode('alpha')
  if (player.is_dead) then
    hud:drawDeathScreen()
  end
  hud:draw(canvas)
  fpsGraph.drawGraphs({graph})
end
