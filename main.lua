require 'globals'
local fpsGraph = require 'vendor/FPSGraph'
local controls = require'controls'.get('player')
local HUD = require 'hud'
local PlayerMenu = require 'player_menu'

local Level = require 'level'

local hud
local graph
local player_menu

local level

local debug_world = false

function love.load()
  graph = fpsGraph.createGraph(10, 50, 50, 30, 0.5, false)
  level = Level.new()
  player_menu = PlayerMenu.new(level.player)
  hud = HUD.new(level.player)
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
    level.world:update(dt)
    level.map:update(dt)
    controls:update(dt)
  end
  level.camera:setScale(CANVAS_SCALE)
  level.camera:setPosition(level.player.x, level.player.y)
  fpsGraph.updateFPS(graph, dt)
end

function love.draw()
  love.graphics.setColor({255, 255, 255, 1})
  level.camera:draw(function(l, t, w, h)
    level.map:draw(-l, -t, CANVAS_SCALE, CANVAS_SCALE)
    if (debug_world) then
      love.graphics.setColor({255, 0, 0, 1})
      for _, body in pairs(level.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
          local shape = fixture:getShape()
          love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
        end
      end
    end
  end)
  player_menu:draw()
  if (level.player.is_dead) then
    hud:drawDeathScreen()
  end
  hud:draw()
  fpsGraph.drawGraphs({graph})
end
