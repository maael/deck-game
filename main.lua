require 'globals'
local assets = require 'assets'
local HUD = require 'hud'
local PlayerMenu = require 'player_menu'
local game_state = require 'game_state'
local player = require "player"

local Level = require 'level'

local hud
local player_menu

local level

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setFont(assets.fonts.default)
  level = Level.new('assets/dungeon.lua')
  player_menu = PlayerMenu.new(level.player)
  hud = HUD.new(level.player)
end

function love.keypressed(key)
  level.player.controls:handlePressed('keyboard', key)
  player_menu.controls:handlePressed('keyboard', key)
end

function love.gamepadpressed(key)
  level.player.controls:handlePressed('gamepad', key)
  player_menu.controls:handlePressed('gamepad', key)
end

function love.update(dt)
  love.window.setTitle('DeckGame v0.0.1 (FPS: ' .. love.timer.getFPS() .. ')')
  player_menu:update(dt)
  player_menu.controls:update(dt)
  if (game_state.state ~= 'paused') then
    level.world:update(dt)
    level.map:update(dt)
    level.player.controls:update(dt)
  end
  level.camera:setScale(CANVAS_SCALE)
  level.camera:setPosition(level.player.x, level.player.y)
  hud:update(dt)
  level.lights:Update()
end

function love.draw()
  love.graphics.setColor({255, 255, 255, 1})
  level.camera:draw(function(l, t, w, h)
    level.map:draw(-l, -t, CANVAS_SCALE, CANVAS_SCALE)
    level.lights:Draw()
    if (DEBUG_WORLD) then
      love.graphics.setColor({255, 0, 0, 1})
      for _, body in pairs(level.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
          local shape = fixture:getShape()
          love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
        end
      end
    end
  end)
  hud:draw(level)
  player_menu:draw()
end
