local InteractiveEntity = {}
InteractiveEntity.__index = InteractiveEntity

function InteractiveEntity.new (world, x, y, object_type, item_type, tile_set_img, sprite_batch)
  local color = {191, 191, 191, 1}
  local sprite_quad = nil
  local sprite = nil
  if (item_type == "heal_potion") then
    color = {255, 0, 0, 0.5}
    sprite_quad = love.graphics.newQuad(7 * 16, 0 * 16, 16, 16, tile_set_img:getWidth(), tile_set_img:getHeight())
    sprite = sprite_batch:add(sprite_quad, x, y - 16, 0, 2, 2)
  elseif (item_type == "key") then
    color = {0,255,0,0.5}
    sprite_quad = love.graphics.newQuad(5 * 16, 0 * 16, 16, 16, tile_set_img:getWidth(), tile_set_img:getHeight())
    sprite = sprite_batch:add(sprite_quad, x, y - 16, 0, 2, 2)
  else
    color = {0, 0, 255, 0.5}
  end
  local interactive_entity = {
    x = x,
    y = y - 16,
    base_y = y - 16,
    size = 16,
    bounce_height = 3,
    bounce_speed = 2,
    bounce_direction = 1,
    object_type = object_type,
    item_type = item_type,
    color = color,
    sprite = sprite,
    sprite_quad = sprite_quad,
    sprite_batch = sprite_batch,
    physics = {},
    debug = false,
    is_active = true
  }
  interactive_entity.physics.body = love.physics.newBody(world, interactive_entity.x + 8, interactive_entity.y + 8, "static")
  interactive_entity.physics.shape = love.physics.newRectangleShape(0, 0, interactive_entity.size,interactive_entity.size)
  interactive_entity.physics.fixture = love.physics.newFixture(interactive_entity.physics.body, interactive_entity.physics.shape)
  interactive_entity.physics.body:setFixedRotation(true)
  interactive_entity.physics.fixture:setSensor(true)
  interactive_entity.physics.fixture:setUserData(interactive_entity)
  setmetatable(interactive_entity, InteractiveEntity)
  return interactive_entity
end

function InteractiveEntity:update (dt)
  if (self.object_type == "pickup_item") then
    self.y = self.y - (self.bounce_direction * dt * self.bounce_speed)
    if (self.y >= self.base_y or self.y <= self.base_y - self.bounce_height) then
      self.bounce_direction = -self.bounce_direction
    end
  end
end

function InteractiveEntity:onPickup(player)
  self.is_active = false
  if (self.sprite_batch and self.sprite) then
    self.sprite_batch:set(self.sprite, 0, 0, 0, 0, 0)
  end
  player:handlePickup(self)
end

function InteractiveEntity:draw ()
  if (self.object_type == "pickup_item") then
    love.graphics.setColor({0, 0, 0, 0.5})
    if (self.debug) then
      love.graphics.polygon("line", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
    end
    local shadow_width = 4 + self.bounce_height - (self.base_y - self.y)
    love.graphics.ellipse( "fill", self.x + 8, self.base_y + 16, shadow_width, 2)
    if (self.sprite and self.sprite_quad and self.sprite_batch) then
      self.sprite_batch:set(self.sprite, self.sprite_quad, self.x * 2, self.y * 2, 0, 2, 2)
    else
      love.graphics.setColor(self.color)
      love.graphics.rectangle( "fill", self.x, self.y, 16, 16)
    end
  else
    love.graphics.setColor(self.color)
    love.graphics.rectangle( "fill", self.x, self.y, 16, 16)
  end
end

return InteractiveEntity