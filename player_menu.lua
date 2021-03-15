local controls = require'controls'.get('player_menu')
local PlayerMenu = {}
PlayerMenu.__index = PlayerMenu

function PlayerMenu.new()
  local player_menu = {is_open = false}
  setmetatable(player_menu, PlayerMenu)

  controls:addAction('ESCAPE', function()
    self.is_open = not self.is_open
  end)
  return player_menu
end

function PlayerMenu:update(dt)
end

function PlayerMenu:draw()
  if (self.is_open) then
    love.graphics.setColor(255, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, 100, 100)
  end
end

return PlayerMenu
