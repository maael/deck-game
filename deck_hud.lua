local controls = require'controls'.get('player')
local assets = require'assets'
local DeckHud = {}
DeckHud.__index = DeckHud

function DeckHud.new(player)
  local deck_hud = {}
  setmetatable(deck_hud, DeckHud)
  deck_hud.player = player
  deck_hud.selected_card = 2
  controls:addAction('CARD_LEFT', function ()
    local new_selected = deck_hud.selected_card - 1
    if (new_selected > 0) then
      deck_hud.selected_card = deck_hud.selected_card - 1
    end
  end, 'down')
  controls:addAction('CARD_RIGHT', function ()
    local new_selected = deck_hud.selected_card + 1
    if (new_selected <= table.getn(deck_hud.player.hand)) then
      deck_hud.selected_card = new_selected
    end
  end, 'down')
  controls:addAction('CARD_USE', function ()
    local should_move_selected = deck_hud.selected_card == table.getn(deck_hud.player.hand)
    local playing_card = deck_hud.player.hand[deck_hud.selected_card]
    player:playCard(playing_card, deck_hud.selected_card)
    if (should_move_selected) then
      local new_selected = deck_hud.selected_card - 1
      if (new_selected > 0) then
        deck_hud.selected_card = deck_hud.selected_card - 1
      end
    end
  end, 'down')
  return deck_hud
end

function DeckHud:update()

end

function DeckHud:get_card_dimensions()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local card_width = width / 10
  local img_h = assets.cards.hp:getHeight()
  local img_w = assets.cards.hp:getWidth()
  local card_height = (img_h / img_w) * card_width
  return width, height, img_w, img_h, card_width, card_height
end

function DeckHud:draw_hand()
  love.graphics.setColor(255, 255, 255, 1)
  local width, height, img_w, img_h, card_width, card_height = self:get_card_dimensions()
  local left_pad = 200
  local gap = 10
  for i, card in pairs(self.player.hand or {}) do
    local img = card.img
    local card_height_mod = self.selected_card == i and 1 or 0.6
    love.graphics.draw(img, left_pad + (card_width * (i - 1)) + (gap * (i - 1)), height - (card_height * card_height_mod), 0, card_width / img_w,  card_height / img_h)
  end
end

function DeckHud:draw_deck()
  local width, height, img_w, img_h, card_width, card_height = self:get_card_dimensions()
  local x, y = 50, height - (card_height * 1.2)
  love.graphics.rectangle("line", x, y, card_width, card_height)
  for i, card in pairs(self.player.deck or {}) do
    love.graphics.setColor(0, 0, 255, 1)
    love.graphics.rectangle("fill", x, y - ((i - 1) * 2), card_width, card_height)
  end
end

function DeckHud:draw_discard()
  love.graphics.setColor(255, 255, 255, 1)
  local width, height, img_w, img_h, card_width, card_height = self:get_card_dimensions()
  local x, y = width - (card_width + 50), height - (card_height * 1.2)
  love.graphics.rectangle("line", x, y, card_width, card_height)
  for i, card in pairs(self.player.discard or {}) do
    love.graphics.draw(card.img, x, y - ((i - 1) * 2), 0, card_width / img_w,  card_height / img_h)
  end
end

function DeckHud:draw()
  love.graphics.push()
  self:draw_deck()
  self:draw_discard()
  self:draw_hand()
  love.graphics.pop()
end

return DeckHud
