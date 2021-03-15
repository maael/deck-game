require "globals"
local sti = require "vendor/sti"
local Camera = require 'vendor/STALKER-X/camera'
local fpsGraph = require 'vendor/FPSGraph'
local controls = require "controls".get("player")
local HUD = require "hud"
local Player = require "player"
local Enemy = require "enemy"
local InteractiveEntity = require "interactive_entity"

local player
local hud
local camera
local canvas
local graph

function BeginContact (a, b, coll)
  local a_data = a:getUserData()
  local b_data = b:getUserData()
  if (a_data.is_player) then
    if (b_data.handleCollidePlayer) then
      b_data:handleCollidePlayer(a_data)
    elseif (b_data.onPickup) then
      b_data:onPickup(a_data)
    end
  end
end

function love.load ()
  graph = fpsGraph.createGraph(10, 50)

  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.physics.setMeter(GRID_SIZE)
	world = love.physics.newWorld(0, 0)
  world:setCallbacks(BeginContact)
  map = sti("assets/dungeon.lua", { "box2d" })
	map:box2d_init(world)

  love.window.setMode(CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
  camera = Camera(CANVAS_WIDTH / 2, CANVAS_HEIGHT /2, CANVAS_WIDTH, CANVAS_HEIGHT)
  camera:setBounds(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
  camera:setFollowStyle('TOPDOWN_TIGHT')
  camera:setFollowLerp(0.1)

  -- Find player spawn point
  local gameObjects = map.layers["GameObjects"]
  local player_spawn = {x = 0, y = 0}

  for _, object in pairs(gameObjects.objects) do
    if (object.properties.object_type == "player_spawn") then
      player_spawn.x = object.x
      player_spawn.y = object.y
    end
  end

  player = Player.new(world, player_spawn)
  hud = HUD.new(player)

  -- Add Player to custom layer in map
  -- This is the secret sauce that makes collisions work properly
  map:addCustomLayer("Sprites", 7)
	local spriteLayer = map.layers["Sprites"]
	spriteLayer.sprites = { player }
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:update(dt)
      end
		end
	end
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
      if sprite.is_active then
        sprite:draw()
      end
		end
	end

  -- Process game objects
  local tile_set_img = love.graphics.newImage("assets/dungeon_tiles.png")

  local gameObjects = map.layers["GameObjects"]
  for _, object in pairs(gameObjects.objects) do
    if object.properties.object_type ~= nil and object.properties.object_type == "enemy_spawn" then
      table.insert(spriteLayer.sprites, Enemy.new(world, {x = object.x, y= object.y}, player))
    elseif object.properties.object_type ~= nil and object.properties.object_type ~= "player_spawn" then
      table.insert(spriteLayer.sprites, InteractiveEntity.new(world, object.x, object.y, object.properties.object_type, object.properties.item_type, tile_set_img))
    end
  end
  map:removeLayer("GameObjects")
end

function love.keypressed(key)
  controls:handlePressed("keyboard", key)
end

function love.gamepadpressed (key)
  controls:handlePressed("gamepad", key)
end

function love.update(dt)
  love.window.setTitle("DeckGame v0.0.1 (FPS: "..love.timer.getFPS()..")")
  world:update(dt)
  map:update(dt)
  controls:update(dt)
  camera:update(dt)
  camera:follow(player.x, player.y)
  fpsGraph.updateFPS(graph, dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  camera:attach()
  love.graphics.setColor({255, 255, 255, 1})
  map:draw(math.floor(-camera.x + CANVAS_WIDTH / 2), math.floor(-camera.y + CANVAS_HEIGHT / 2))
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
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
    love.graphics.setColor(255, 0, 0, 1)
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf({{1, 0, 0},"YOU DIED", {0, 0, 0}}, 0, (CANVAS_HEIGHT * CANVAS_SCALE) / 2, (CANVAS_WIDTH * CANVAS_SCALE), "center")
  end
  hud:draw(canvas, CANVAS_WIDTH, CANVAS_SCALE)
  fpsGraph.drawGraphs({graph})
end
