local DeckHud = {}
DeckHud.__index = DeckHud

function DeckHud.new(player)
  local deck_hud = {}
  setmetatable(deck_hud, DeckHud)
  deck_hud.player = player
  return deck_hud
end

function DeckHud:update()

end

function DeckHud:draw()
  love.graphics.push()
  love.graphics.setColor(255, 255, 255, 1)
  local height = love.graphics.getHeight()
  local width = love.graphics.getWidth()
  local card_height = height / 5
  local card_width = width / 10
  local center_point = {x = width / 2 - (card_width / 2), y = height - (card_height * 5/16)}
  local hand_size = table.getn(self.player.hand or {})
  local hand_max_width = math.min(width * 3/4, hand_size * card_width)
  local angle_mod = 90 / hand_size
  local start_angle = angle_mod * math.ceil(hand_size / 2)
  local mod_change = 0
  if (hand_size % 2 == 0) then
    mod_change = 0.5
  end
  for i, img in pairs(self.player.hand or {}) do
    local x_offset = (hand_max_width / hand_size) * ((hand_size / 2) - i)
    local y_offset = math.min(math.sqrt((math.ceil(hand_size / 2) - (i - mod_change)) ^ 2) * 20, card_width * 1/2)
    love.graphics.draw(img, center_point.x - x_offset, center_point.y + y_offset,
      (math.pi / 360) * (-start_angle + (i * angle_mod)), 0.04, 0.04, img:getWidth() / 2,
      img:getHeight() / 2)
  end
  love.graphics.pop()
end

return DeckHud
