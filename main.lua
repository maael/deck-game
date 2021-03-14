local sti = require "vendor/sti"
local Camera = require 'vendor/STALKER-X/camera'
local controls = require "controls".get("player")
local HUD = require "hud"
local Player = require "player"
local InteractiveEntity = require "interactive_entity"

local player
local hud
local camera
local canvas

function BeginContact (a, b, coll)
  local a_data = a:getUserData()
  local b_data = b:getUserData()
  if (a_data.is_player and b_data.onPickup) then
    b_data:onPickup(a_data)
  end
end

function love.load ()
  love.window.setTitle("DeckGame v0.0.1")
  camera = Camera(200, 150, 400, 300)
  camera:setFollowStyle('TOPDOWN_TIGHT')
  canvas = love.graphics.newCanvas(400, 300)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.physics.setMeter(16)
	world = love.physics.newWorld(0, 0)
  world:setCallbacks(BeginContact)
  map = sti("assets/dungeon.lua", { "box2d" })
	map:box2d_init(world)

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
    if object.properties.object_type ~= nil and object.properties.object_type ~= "player_spawn" then
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
  world:update(dt)
  map:update(dt)
  controls:update(dt)
  camera:update(dt)
  camera:follow(player.x, player.y)
end

function love.draw()
  camera:attach()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  love.graphics.setColor(1, 1, 1)
  map:draw(0, 0)
  -- Uncommit to view collision debug
  -- love.graphics.setColor(1, 0, 0)
	-- map:box2d_draw(0, 0)

  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, 2, 2)
  love.graphics.setBlendMode('alpha')
  camera:detach()
  hud:draw()
end
