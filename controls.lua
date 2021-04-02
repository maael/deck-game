
local game_state = require 'game_state'

local actions = {
  up = 'UP',
  down = 'DOWN',
  left = 'LEFT',
  right = 'RIGHT',
  interact = 'INTERACT',
  sprint = 'SPRINT',
  escape = 'ESCAPE',
  select = "SELECT",
  card_left = "CARD_LEFT",
  card_right = "CARD_RIGHT",
  card_use = "CARD_USE"
}

local keyboard_map = {
  up = actions.up,
  down = actions.down,
  left = actions.left,
  right = actions.right,
  lshift = actions.sprint,
  e = actions.interact,
  escape = actions.escape,
  q = actions.escape,
  ['return'] = actions.select,
  a = actions.card_left,
  d = actions.card_right,
  s = actions.card_use,
}

local gamepad_map = {
  dpup = actions.up,
  dpdown = actions.down,
  dpleft = actions.left,
  dpright = actions.right,
  leftshoulder = actions.sprint,
  a = actions.interact,
  select = actions.escape,
  ['return'] = actions.select,
}

local InputController = {}
InputController.__index = InputController
local cached = {}

function InputController.new(name, required_game_state)
  local controller = {}
  setmetatable(controller, InputController)
  controller.name = name
  controller.actions = actions
  controller.game_state = required_game_state
  controller.action_map = {}
  controller.release_action_map = {}
  controller.down_action_map = {}
  controller.type = 'keyboard'
  controller.wasDown = {}
  return controller
end

function InputController.get(name, required_game_state)
  name = name or 'DEFAULT'
  if cached[name] == nil then
    cached[name] = InputController.new(name, required_game_state)
  end
  return cached[name]
end

function InputController:setType(type)
  self.type = type
end

function InputController:getTypeMap()
  local specific_map
  if type == 'gamepad' then
    specific_map = gamepad_map
  else
    specific_map = keyboard_map
  end
  return specific_map
end

function InputController:handlePressed(type, key)
  self:setType(type)
end

function InputController:addAction(action, fn, type)
  if type == 'release' then
    self.release_action_map[action] = fn
  elseif type == 'down' then
    self.down_action_map[action] = fn
  else
    self.action_map[action] = fn
  end
end

function InputController:wasKeyDown(key, remove)
  for index, value in ipairs(self.wasDown) do
    if value == key then
      if remove then
        table.remove(self.wasDown, index)
      end
      return true
    end
  end
  return false
end

function InputController:getActionToKeyTable()
  local specific_map = self:getTypeMap()
  local s = {}
  for k, v in pairs(specific_map) do
    s[v] = k
  end
  return s
end

function InputController:isActionDown(action)
  local action_map = self:getActionToKeyTable()
  local action_key = action_map[action]
  return love.keyboard.isDown(action_key)
end

function InputController:update(dt)
  local specific_map = self:getTypeMap()
  for key, action in pairs(specific_map) do
    if (love.keyboard.isDown(key)) then
      if not self:wasKeyDown(key, false) then
        table.insert(self.wasDown, key)
        if (self.down_action_map[action]) then
          if (self.game_state == game_state.state) then
            self.down_action_map[action](dt)
          end
        end
      end
      if (self.action_map[action]) then
        if (self.game_state == game_state.state) then
          self.action_map[action](dt)
        end
      end
    elseif self.release_action_map[action] and self:wasKeyDown(key, true) then
      if (self.game_state == game_state.state) then
        self.release_action_map[action](dt)
      end
    else
      self:wasKeyDown(key, true)
    end
  end
end

return InputController
