local controls = require'controls'.get('player_menu')
local assets = require'assets'
local PlayerMenu = {}
PlayerMenu.__index = PlayerMenu

function PlayerMenu.new(player)
  local player_menu = {is_open = false, player = player, controls = controls, selected = 1, options = {'Character', 'Deck', 'Inventory', 'Exit'}}
  setmetatable(player_menu, PlayerMenu)
  controls:addAction('UP', function()
    player_menu.selected = math.max(player_menu.selected - 1, 1)
  end, 'down')
  controls:addAction('DOWN', function()
    player_menu.selected = math.min(player_menu.selected + 1, #player_menu.options)
  end, 'down')
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
  if (not self.is_open) then return end
  local selected_option = self.options[self.selected]
  if (selected_option == 'Exit') then
    love.event.quit()
  end
end

function PlayerMenu:draw()
  if (self.is_open) then
    local height, width = love.graphics.getHeight(), love.graphics.getWidth()
    local menu_height, menu_width = height / 3, width / 5
    local x, y = width - (menu_width * 2), menu_height
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.ellipse('fill', x + (menu_width / 2), y + menu_height, menu_width * 0.75, menu_height / 10)
    love.graphics.setColor(235, 213, 179, 1)
    love.graphics.rectangle('fill', x, y, menu_width, menu_height, 5, 5)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(assets.fonts.default)
    love.graphics.printf('Menu', x, y + 10, menu_width, 'center')
    love.graphics.setLineWidth(1)
    love.graphics.line(x + 20, y + 25, x + menu_width - 20, y + 25)
    for i, opt in pairs(self.options) do
      love.graphics.printf((self.selected == i and '> ' or '')..opt, x, y + 40 + ((i - 1) * 20), menu_width, 'center')
    end
  end
end

return PlayerMenu
