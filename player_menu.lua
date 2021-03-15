local controls = require'controls'.get('player_menu')
local serialize = require "vendor.ser"
local PlayerMenu = {}
PlayerMenu.__index = PlayerMenu

function PlayerMenu.new(player)
  local player_menu = {is_open = false, player = player, controls = controls, selected = 1, options = {'Exit'}}
  setmetatable(player_menu, PlayerMenu)

  controls:addAction('ESCAPE', function()
    player_menu.is_open = not player_menu.is_open
  end, 'down')
  controls:addAction('SELECT', function()
    player_menu:handleSelect()
  end, 'down')
  return player_menu
end

function PlayerMenu:update(dt)
end

function PlayerMenu:handleSelect()
  local selected_option = self.options[self.selected]
  if (selected_option == 'Exit') then
    love.event.quit()
  end
end

function PlayerMenu:draw()
  if (self.is_open) then
    local side = self.player.x + (2 * GRID_SIZE) >= ((self.player.map.width * GRID_SIZE) - (GRID_SIZE * 5)) and -3 or 1
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.ellipse('fill', self.player.x + (side * (2 * GRID_SIZE)) + GRID_SIZE * 2,
      self.player.y + (GRID_SIZE * 4), GRID_SIZE * 3, 5)
    love.graphics.setColor(235, 213, 179, 1)
    love.graphics.rectangle('fill', (self.player.x + (side * (2 * GRID_SIZE))), self.player.y - (2 * GRID_SIZE),
      GRID_SIZE * 4, GRID_SIZE * 6, 5, 5)
    love.graphics.setColor(0, 0, 0, 1)
    local font = love.graphics.newFont(10)
    font:setFilter('nearest', 'nearest', 0)
    love.graphics.setFont(font)
    love.graphics.printf('Menu', self.player.x + (side * (2 * GRID_SIZE)), self.player.y - (GRID_SIZE * 1.8),
      GRID_SIZE * 4, 'center')
    love.graphics.setLineWidth(1)
    love.graphics.line(self.player.x + (side * (2.5 * GRID_SIZE)), self.player.y - (GRID_SIZE),
      self.player.x + (side * (2 * GRID_SIZE) + GRID_SIZE * 3.5), self.player.y - (GRID_SIZE))
    love.graphics.printf('> Exit', self.player.x + (side * (2 * GRID_SIZE)), self.player.y - (GRID_SIZE * 0.8),
      GRID_SIZE * 4, 'center')
  end
end

return PlayerMenu
