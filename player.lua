local anim8 = require('vendor.anim8')
local Star = require("shadows.Star")
local controls = require'controls'.get('player')
local Inventory = require('inventory')
local cards = require('cards')
local Player = {}
Player.__index = Player

function Player.new(level, player_spawn)
  local player = {
    level = level,
    camera = level.camera,
    name = 'Player',
    is_player = true,
    health = 100,
    x = player_spawn.x,
    y = player_spawn.y,
    size = GRID_SIZE,
    speed = 128,
    sprint_speed = 200,
    sprinting = false,
    inventory = Inventory.new(),
    world = level.world,
    physics = {},
    collision_x_limit = nil,
    collision_y_limit = nil,
    is_active = true,
    animations = {},
    current_direction = 'right',
    current_anim = 'idle',
    is_dead = false,
    debug = DEBUG_PLAYER,
    invulnerabe = true,
    map = level.map,
    max_hand_size = 3,
    max_mana = 3,
    mana = 2,
    mana_regen = 1,
    clock = 0,
    hand = {
      cards.hp,
      cards.hp,
      cards.manastorm,
      cards.manastorm
    },
    deck = {cards.manastorm},
    discard = {},
  }
  player.light = Star:new(level.lights, (CANVAS_WIDTH * CANVAS_SCALE) * 0.8)
  local idle_spritesheet = love.graphics.newImage('assets/spritesheets/knight_idle_spritesheet.png')
  local idle_grid = anim8.newGrid(GRID_SIZE, GRID_SIZE, idle_spritesheet:getWidth(), idle_spritesheet:getHeight())
  local idle_animation = anim8.newAnimation(idle_grid('1-6', 1), 0.2)
  player.animations.idle = {anim = idle_animation, sprites = idle_spritesheet}
  local run_spritesheet = love.graphics.newImage('assets/spritesheets/knight_run_spritesheet.png')
  local run_grid = anim8.newGrid(GRID_SIZE, GRID_SIZE, run_spritesheet:getWidth(), run_spritesheet:getHeight())
  local run_animation = anim8.newAnimation(run_grid('1-6', 1), 0.2)
  player.animations.run = {anim = run_animation, sprites = run_spritesheet}
  setmetatable(player, Player)
  player.physics.body = love.physics.newBody(level.world, player.x, player.y, 'dynamic')
  player.physics.shape = love.physics.newRectangleShape(0, player.size / 4, player.size, player.size / 2)
  player.physics.fixture = love.physics.newFixture(player.physics.body, player.physics.shape)
  player.physics.body:setFixedRotation(true)
  player.physics.fixture:setUserData(player)
  return player
end

function Player:addCardToHand (card)
  table.insert(self.hand, card)
end

function Player:addCardToDeck (card)
  table.insert(self.deck, card)
end

function Player:setHealth(modifier)
  self.health = math.max(math.min(self.health + modifier, 100), 0)
  if (self.health == 0 and not self.invulnerabe) then
    self.is_dead = true
    self.is_active = false
  end
end

function Player:setMana(modifier)
  self.mana = math.max(math.min(self.mana + modifier, self.max_mana), 0)
end

function shuffleTable (x)
  local shuffled = {}
  for i, v in ipairs(x) do
    local pos = math.random(1, #shuffled+1)
    table.insert(shuffled, pos, v)
  end
  return shuffled
end

function Player:playCard(card, idx)
  if (self.mana >= card.mana) then
    self:setMana(-card.mana)
  else
    return false
  end
  if (card.onPlay) then
    card.onPlay(self)
  end
  table.insert(self.discard, card)
  table.remove(self.hand, idx)
  if (#self.hand == 0) then
    if (#self.deck == 0) then
      self.deck = shuffleTable(self.discard)
      self.discard = {}
    end
    for i=1,self.max_hand_size do
      local pulled_card = table.remove(self.deck, 1)
      if (pulled_card) then
        table.insert(self.hand, pulled_card)
      else
        self.deck = shuffleTable(self.discard)
        self.discard = {}
        local pulled_card = table.remove(self.deck, 1)
        if (pulled_card) then
          table.insert(self.hand, pulled_card)
        end
      end
    end
  end
  return true
end

function Player:handleInteract()
  self.world:queryBoundingBox(self.x - GRID_SIZE, self.y - GRID_SIZE, self.x + GRID_SIZE, self.y + GRID_SIZE,
    function(fixture)
      local should_continue_search = true
      local data = fixture:getUserData()
      if (data and data.is_lootable and data.handleLoot) then
        data:handleLoot(self)
      end
      return should_continue_search
    end)
end

function Player:update(dt)
  local original = math.floor(self.clock)
  self.clock = self.clock + dt
  local post = math.floor(self.clock)
  if (original < post) then
    self:setMana(1)
  end
  self.sprinting = controls:isActionDown('SPRINT')
  local speed = (self.sprinting and self.sprint_speed or self.speed)
  local x_vel = 0
  local y_vel = 0
  if (controls:isActionDown('RIGHT')) then
    x_vel = x_vel + speed
  end
  if (controls:isActionDown('LEFT')) then
    x_vel = x_vel + -speed
  end
  if (controls:isActionDown('UP')) then
    y_vel = y_vel + -speed
  end
  if (controls:isActionDown('DOWN')) then
    y_vel = y_vel + speed
  end
  if (x_vel ~= 0 or y_vel ~= 0) then
    if (x_vel > 0) then
      self.current_direction = 'right'
    elseif (x_vel < 0) then
      self.current_direction = 'left'
    end
    self.current_anim = 'run'
  else
    self.current_anim = 'idle'
  end
  self.physics.body:setLinearVelocity(x_vel, y_vel)
  if (controls:isActionDown('INTERACT')) then
    self:handleInteract()
  end
  self.x = self.physics.body:getX()
  self.y = self.physics.body:getY()
  self.animations[self.current_anim].anim:update(dt)
  local cam_x, cam_y = self.level.camera:toScreen(self.x, self.y)
  self.light:SetPosition(cam_x, cam_y)
end

function Player:draw()
  love.graphics.push()
  local direction_modifier = self.current_direction == 'right' and 1 or -1
  love.graphics.setColor({255, 255, 255, 1})
  self.animations[self.current_anim].anim:draw(self.animations[self.current_anim].sprites, self.x, self.y, 0,
    direction_modifier, 1, self.size / 2, self.size / 2)
  if (self.debug) then
    love.graphics.setColor(255, 0, 0, 1);
    love.graphics.polygon('line', self.physics.body:getWorldPoints(self.physics.shape:getPoints()))
    -- Show interaction range points
    love.graphics.setColor(255, 0, 0, 1)
    love.graphics.points(self.x - GRID_SIZE, self.y - GRID_SIZE)
    love.graphics.setColor(0, 255, 0, 1)
    love.graphics.points(self.x + GRID_SIZE, self.y + GRID_SIZE)
    love.graphics.setColor(0, 0, 255, 1)
    love.graphics.points(self.x, self.y)
  end
  love.graphics.pop()
end

return Player
