local Effect = {}
Effect.__index = Effect

function Effect.new(player)
  local effect = {player = player}
  setmetatable(effect, Effect)
  return effect
end

function Effect:update (dt)
  if (self.onUpdate ~= nil) then
    self.onUpdate(dt, self.player, self)
  end
end

function Effect:draw ()
  if (self.onDraw ~= nil) then
    if (self.color) then
      love.graphics.setColor(self.color)
    else
      love.graphics.setColor(255, 255, 255, 1)
    end
    self.onDraw(self.player, self)
  end
end

return Effect
