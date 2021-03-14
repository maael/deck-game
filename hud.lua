local HUD = {}
HUD.__index = HUD

function HUD.new (player)
  local hud = {}
  setmetatable(hud, HUD)
  hud.player = player
  return hud
end

function HUD:draw ()
  love.graphics.setColor(191, 191, 191, 255)
	love.graphics.rectangle( "fill", 8, 8, 104, 16, 2, 2)
  if self.player.health ~= 0 then
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle( "fill", 10, 10, 100 * (self.player.health / 100), 12, 2, 2)
  end
  love.graphics.reset()
end

return HUD