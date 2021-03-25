local DeckHud = require "deck_hud"
local assets = require "assets"
local HUD = {}
HUD.__index = HUD

function HUD.new(player)
  local hud = {}
  setmetatable(hud, HUD)
  hud.player = player
  hud.deck_hud = DeckHud.new(player)
  return hud
end

function HUD:drawMinimap(canvas)
  local minimap_width, minimap_height = canvas:getWidth() * 0.5, canvas:getHeight() * 0.5
  local minimap_x, minimap_y = (CANVAS_WIDTH * CANVAS_SCALE) - (minimap_width) - 10, 10
  love.graphics.setColor(46, 49, 49, 0.5)
  love.graphics.rectangle('fill', minimap_x - 2, minimap_y - 2, minimap_width + 4, minimap_height + 4, 2, 2)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.draw(canvas, minimap_x, minimap_y, 0, 0.5, 0.5)
  love.graphics.setBlendMode('alpha')
  love.graphics.setColor(255, 255, 255, 1)
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

function HUD:draw(canvas)
  self.deck_hud:draw()
  self:drawMinimap(canvas)
  self:drawMana()
  self:drawHealth()
  love.graphics.reset()
end

return HUD
