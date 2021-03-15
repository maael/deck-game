local actions = {
  up = 'UP',
  down = 'DOWN',
  left = 'LEFT',
  right = 'RIGHT',
  interact = 'INTERACT',
  sprint = 'SPRINT',
  escape = 'ESCAPE',
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
}

local gamepad_map = {
  dpup = actions.up,
  dpdown = actions.down,
  dpleft = actions.left,
  dpright = actions.right,
  leftshoulder = actions.sprint,
  a = actions.interact,
  select = actions.escape,
}

local InputController = {}
InputController.__index = InputController
local cached = {}

function InputController.new(name)
  local controller = {}
  setmetatable(controller, InputController)
  controller.name = name
  controller.actions = actions
  controller.action_map = {}
  controller.release_action_map = {}
  controller.type = 'keyboard'
  controller.wasDown = {}
  return controller
end

function InputController.get(name)
  name = name or 'DEFAULT'
  if cached[name] == nil then
    cached[name] = InputController.new(name)
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
      end
      if (self.action_map[action]) then
        self.action_map[action](dt)
      end
    elseif self.release_action_map[action] and self:wasKeyDown(key, true) then
      self.release_action_map[action](dt)
    end
  end
end

return InputController
