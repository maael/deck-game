local assets = require "assets"
local Effect = require "effect"

local cards = {
  hp = {
    img = assets.cards.hp,
    onPlay = function (player)
      player:setHealth(50)
      local effect = Effect.new(player)
      effect.type = 'player_effect'
      effect.color = {0, 255, 0, 0.5}
      effect.attached = true
      effect.is_active = true
      effect.image = assets.animations.effect.spiral_white.image
      effect.anim = assets.animations.effect.spiral_white.anim:clone()
      effect.onUpdate = function (dt, player, effect)
        effect.anim:update(dt)
        if (effect.anim.status == 'paused') then
          effect.is_active = false
        end
      end
      effect.onDraw = function (player, effect)
        local anim_w, anim_h = effect.anim:getDimensions()
        effect.anim:draw(effect.image, player.x - (anim_w / 4), player.y - (anim_h / 2), 0, 1, 1, player.size / 2, player.size / 2)
      end
      table.insert(player.level.spriteLayer.sprites, effect)
    end,
    mana = 3
  },
  chest = {
    img = assets.cards.chest,
    mana = 1
  },
  slash = {
    img = assets.cards.artifact,
    mana = 1,
    onPlay = function (player)
      local effect = Effect.new(player)
      effect.type = 'player_effect'
      effect.attached = true
      effect.is_active = true
      effect.image = assets.animations.effect.slash_white.image
      effect.anim = assets.animations.effect.slash_white.anim:clone()
      effect.physics = {}
      effect.direction = player.current_direction
      effect.source = player
      effect.offset_base = {
        x = player.x,
        y = player.y
      }
      effect.dir_offset = 0
      effect.damage = 25
      effect.onCollideEnemy = function (enemy, effect)
        if (effect.is_active) then
          enemy:setHealth(-effect.damage)
        end
      end
      effect.onUpdate = function (dt, player, effect)
        local ex, ey = effect.physics.body:getPosition()
        ex = ex - effect.dir_offset;
        local anim_w, anim_h = effect.anim:getDimensions()
        local xo, yo = player.x - effect.offset_base.x, player.y - effect.offset_base.y
        local dir_modifier = effect.direction == 'left' and 1 or -1
        effect.dir_offset = (player.current_direction ~= effect.direction) and (dir_modifier * ((3 * (anim_w / 4)) + (player.size / 2))) or 0
        effect.offset_base = {x = player.x, y = player.y}
        effect.physics.body:setPosition(ex + xo + effect.dir_offset, ey + yo)
        effect.anim:update(dt)
        if (effect.anim.status == 'paused') then
          effect.is_active = false
        end
      end
      effect.onDraw = function (player, effect)
        local direction_modifier = player.current_direction == 'right' and 1 or -1
        effect.anim:draw(effect.image, player.x, player.y - (effect.image:getHeight() / 4), 0,
        direction_modifier, 1, player.size / 2, player.size / 2)
      end
      local anim_w, anim_h = effect.anim:getDimensions()
      local direction_modifier = player.current_direction == 'right' and 1 or -1
      effect.physics.body = love.physics.newBody(player.world, player.x + (direction_modifier * player.size / 2), player.y + (player.size / 2), 'static')
      effect.physics.shape = love.physics.newRectangleShape(direction_modifier * anim_w / 4, -anim_h / 4, anim_w, anim_h)
      effect.physics.fixture = love.physics.newFixture(effect.physics.body, effect.physics.shape)
      effect.physics.body:setFixedRotation(true)
      effect.physics.fixture:setUserData(effect)
      effect.physics.fixture:setSensor(true)
      table.insert(player.level.spriteLayer.sprites, effect)
    end
  },
  manastorm = {
    img = assets.cards.manastorm,
    mana = 2,
    onPlay = function (player)
      local effect = Effect.new(player)
      effect.type = 'player_effect'
      effect.attached = true
      effect.is_active = true
      effect.image = assets.animations.effect.bolt_white.image
      effect.anim = assets.animations.effect.bolt_white.anim:clone()
      effect.physics = {}
      effect.direction = player.current_direction
      effect.source = player
      effect.damage = 50
      effect.onCollideEnemy = function (enemy, effect)
        if (effect.is_active) then
          enemy:setHealth(-effect.damage)
        end
      end
      effect.onCollideNotPlayer = function (effect, collided_with_fixture, collided_with_data)
        if ((collided_with_fixture == nil or collided_with_fixture:isSensor() == false) and effect.is_active) then
          effect.is_active = false
        end
      end
      effect.onUpdate = function (dt, player, effect)
        effect.anim:update(dt)
      end
      effect.onDraw = function (player, effect)
        local direction_modifier = player.current_direction == 'right' and 1 or -1
        effect.anim:draw(effect.image, effect.physics.body:getX(), effect.physics.body:getY(), 0,
          direction_modifier, 1, player.size / 2, player.size / 2)
      end
      local anim_w, anim_h = effect.anim:getDimensions()
      local direction_modifier = player.current_direction == 'right' and 1 or -1
      effect.physics.body = love.physics.newBody(player.world, player.x, player.y, 'dynamic')
      effect.physics.shape = love.physics.newRectangleShape(anim_w / 4, anim_h / 4, anim_w / 2, anim_h / 4)
      effect.physics.fixture = love.physics.newFixture(effect.physics.body, effect.physics.shape)
      effect.physics.body:setFixedRotation(true)
      effect.physics.fixture:setUserData(effect)
      effect.physics.fixture:setSensor(true)
      effect.physics.body:setLinearVelocity(direction_modifier * 100, 0)
      table.insert(player.level.spriteLayer.sprites, effect)
    end
  }
}

return cards