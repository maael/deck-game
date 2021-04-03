local assets = require "assets"

local cards = {
  hp = {
    img = assets.cards.hp,
    onPlay = function (player)
      player:setHealth(20)
    end,
    mana = 3
  },
  chest = {
    img = assets.cards.chest,
    mana = 1
  },
  manastorm = {
    img = assets.cards.manastorm,
    mana = 2,
    onPlay = function (player)
      local effect = {
        type = 'player_effect',
        attached = true,
        is_active = true,
        image = assets.animations.effect.slash_white.image,
        anim = assets.animations.effect.slash_white.anim:clone(),
        physics = {},
        direction = player.current_direction,
        source = player,
        offset_base = {
          x = player.x,
          y = player.y
        },
        dir_offset = 0,
        damage = 5,
        update = function (dt, effect, player)
          local ex, ey = effect.physics.body:getPosition()
          ex = ex - effect.dir_offset;
          local anim_w, anim_h = effect.anim:getDimensions()
          local xo, yo = player.x - effect.offset_base.x, player.y - effect.offset_base.y
          local dir_modifier = effect.direction == 'left' and 1 or -1
          effect.dir_offset = (player.current_direction ~= effect.direction) and (dir_modifier * ((3 * (anim_w / 4)) + (player.size / 2))) or 0
          effect.offset_base = {x = player.x, y = player.y}
          effect.physics.body:setPosition(ex + xo + effect.dir_offset, ey + yo)
          effect.anim:update(dt)
        end,
        onCollide = function (enemy, effect)
          enemy:setHealth(-effect.damage)
        end,
        onEnd = function (effect)
          print("END")
        end
      }
      local anim_w, anim_h = effect.anim:getDimensions()
      local direction_modifier = player.current_direction == 'right' and 1 or -1
      effect.physics.body = love.physics.newBody(player.world, player.x + (direction_modifier * player.size / 2), player.y + (player.size / 2), 'static')
      effect.physics.shape = love.physics.newRectangleShape(direction_modifier * anim_w / 4, -anim_h / 4, anim_w, anim_h)
      effect.physics.fixture = love.physics.newFixture(effect.physics.body, effect.physics.shape)
      effect.physics.body:setFixedRotation(true)
      effect.physics.fixture:setUserData(effect)
      effect.physics.fixture:setSensor(true)
      table.insert(player.effects, effect)
    end
  }
}

return cards