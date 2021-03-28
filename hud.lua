local fpsGraph = require 'vendor.FPSGraph'
local DeckHud = require "deck_hud"
local assets = require "assets"
local HUD = {}
HUD.__index = HUD

function HUD.new(player)
  local hud = {}
  setmetatable(hud, HUD)
  hud.player = player
  hud.deck_hud = DeckHud.new(player)
  hud.fpsGraph = fpsGraph.createGraph(10, 50, 50, 30, 0.5, false)
  return hud
end

function HUD:drawDeathScreen()
  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle('fill', 0, 0, CANVAS_WIDTH * CANVAS_SCALE, CANVAS_HEIGHT * CANVAS_SCALE)
  love.graphics.setColor(255, 0, 0, 1)
  love.graphics.setFont(love.graphics.newFont(32))
  love.graphics.printf({{1, 0, 0}, 'YOU DIED', {0, 0, 0}}, 0, (CANVAS_HEIGHT * CANVAS_SCALE) / 2,
    (CANVAS_WIDTH * CANVAS_SCALE), 'center')
end

function HUD:drawHealth()
  love.graphics.setColor(191, 191, 191, 255)
  love.graphics.rectangle('fill', 8, 8, 104, 16, 2, 2)
  if self.player.health ~= 0 then
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle('fill', 10, 10, 100 * (self.player.health / 100), 12, 2, 2)
  end
end

function HUD:drawMana()
  for m=1,self.player.max_mana do
    local icon
    if (m <= self.player.mana) then
      icon = assets.items.shard_blue
    else
      icon = assets.items.shard_grey
    end
    love.graphics.draw(icon, 10 + (20 * (m - 1)), 30)
  end
end

function HUD:update(dt)
  fpsGraph.updateFPS(self.fpsGraph, dt)
end

function HUD:draw(level)
  self.deck_hud:draw()
  self:drawMana()
  self:drawHealth()
  love.graphics.setColor({255, 255, 255, 1})
  fpsGraph.drawGraphs({self.fpsGraph})
  if (level.player.is_dead) then
    self:drawDeathScreen()
  end
end

return HUD
