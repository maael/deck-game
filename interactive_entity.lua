local InteractiveEntity = {}
InteractiveEntity.__index = InteractiveEntity

function InteractiveEntity.new(world, x, y, object_type, item_type, tile_set_img, tile_set_quad)
  local color = {191, 191, 191, 0.5}
  local sprite_quad = nil
  local interactive_entity = {
    x = x,
    y = y - GRID_SIZE,
    base_y = y - GRID_SIZE,
    size = GRID_SIZE,
    bounce_height = 3,
    bounce_speed = 2,
    bounce_direction = 1,
    object_type = object_type,
    item_type = item_type,
    color = color,
    sprite_quad = sprite_quad,
    physics = {},
    debug = false,
    is_active = true,
    tile_set_img = tile_set_img,
    tile_set_quad = tile_set_quad,
  }
  interactive_entity.physics.body = love.physics.newBody(world, interactive_entity.x + (GRID_SIZE / 2),
    interactive_entity.y + (GRID_SIZE / 2), 'static')
  interactive_entity.physics.shape = love.physics.newRectangleShape(0, 0, interactive_entity.size,
    interactive_entity.size)
  interactive_entity.physics.fixture = love.physics.newFixture(interactive_entity.physics.body,
    interactive_entity.physics.shape)
  interactive_entity.physics.body:setFixedRotation(true)
  interactive_entity.physics.fixture:setSensor(true)
  interactive_entity.physics.fixture:setUserData(interactive_entity)
  setmetatable(interactive_entity, InteractiveEntity)
  return interactive_entity
end

function InteractiveEntity:update(dt)
  if (self.object_type == 'pickup_item') then
    self.y = self.y - (self.bounce_direction * dt * self.bounce_speed)
    if (self.y >= self.base_y or self.y <= self.base_y - self.bounce_height) then
      self.bounce_direction = -self.bounce_direction
    end
  end
end

function InteractiveEntity:onPickup(player)
  if (not self.is_active) then return end
  if (self.object_type == 'pickup_item') then
    self.is_active = false
    player:handlePickup(self)
  elseif (self.object_type == 'stairs') then
    love.event.quit()
  end
end

function InteractiveEntity:draw()
  if (self.object_type == 'pickup_item') then
    if (self.tile_set_img and self.tile_set_quad) then
      love.graphics.setColor({255, 255, 255, 1})
      love.graphics.draw(self.tile_set_img, self.tile_set_quad, self.x, self.y)
    else
      love.graphics.setColor(self.color)
      love.graphics.rectangle('fill', self.x, self.y, GRID_SIZE, GRID_SIZE)
    end
    if (self.debug) then
      love.graphics.polygon('line', self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
    end
    love.graphics.setColor({0, 0, 0, 0.5})
    local shadow_width = 4 + self.bounce_height - (self.base_y - self.y)
    love.graphics.ellipse('fill', self.x + (GRID_SIZE / 2), self.base_y + GRID_SIZE, shadow_width, 2)
  elseif self.object_type == 'stairs' then
    if (self.tile_set_img and self.tile_set_quad) then
      love.graphics.setColor({255, 255, 255, 1})
      love.graphics.draw(self.tile_set_img, self.tile_set_quad, self.x, self.y)
    end
  else
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, GRID_SIZE, GRID_SIZE)
  end
end

return InteractiveEntity
