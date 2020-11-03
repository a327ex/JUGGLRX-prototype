moonscript = true
require('engine')
init = function()
  black = Color(0, 0, 0, 1)
  white = Color(1, 1, 1, 1)
  bg1 = Color('#303030')
  bg2 = Color('#272727')
  fg1 = Color('#dadada')
  fg2 = Color('#b0a89f')
  fg3 = Color('#606060')
  error1 = Color('#7a4d4e')
  river = Color('#7badc4')
  yellow = Color('#facf00')
  orange = Color('#f07021')
  blue = Color('#019bd6')
  green = Color('#8bbf40')
  green2 = Color('#017866')
  red = Color('#e91d39')
  purple = Color('#8e559e')
  graphics.set_background_color(bg1)
  graphics.set_color(fg1)
  input.set_mouse_grabbed(true)
  slow_amount = 1
  sfx = SoundTag()
  sfx.volume = 0.5
  music = SoundTag()
  music.volume = 0.5
  switch1 = Sound('Switch.ogg', {
    tags = {
      sfx
    }
  })
  wind1 = Sound('Wind Bolt 20.ogg', {
    tags = {
      sfx
    }
  })
  shoot1 = Sound('Shooting Projectile (Classic) 11.ogg', {
    tags = {
      sfx
    }
  })
  hit1 = Sound('Player Takes Damage 17.ogg', {
    tags = {
      sfx
    }
  })
  hit2 = Sound('Player Takes Damage 2.ogg', {
    tags = {
      sfx
    }
  })
  hit3 = Sound('Kick 16.ogg', {
    tags = {
      sfx
    }
  })
  hit4 = Sound('Wood Heavy 5.ogg', {
    tags = {
      sfx
    }
  })
  stick1 = Sound('Mud footsteps 7.ogg', {
    tags = {
      sfx
    }
  })
  stick2 = Sound('Mud footsteps 9.ogg', {
    tags = {
      sfx
    }
  })
  error1 = Sound('Player Takes Damage 12.ogg', {
    tags = {
      sfx
    }
  })
  pop1 = Sound('Pop sounds 10.ogg', {
    tags = {
      sfx
    }
  })
  blue1 = Sound('Water Bolt 9.ogg', {
    tags = {
      sfx
    }
  })
  blue2 = Sound('Water Bolt 8.ogg', {
    tags = {
      sfx
    }
  })
  red1 = Sound('Buff 11.ogg', {
    tags = {
      sfx
    }
  })
  red2 = Sound('Magical Impact 25.ogg', {
    tags = {
      sfx
    }
  })
  red3 = Sound('Sci Fi Beam 3.ogg', {
    tags = {
      sfx
    }
  })
  red4 = Sound('Magical Swoosh 21.ogg', {
    tags = {
      sfx
    }
  })
  yellow1 = Sound('Magical Impact 6.ogg', {
    tags = {
      sfx
    }
  })
  green1 = Sound('Magical Impact 5.ogg', {
    tags = {
      sfx
    }
  })
  alert1 = Sound('Alert sounds 3.ogg', {
    tags = {
      sfx
    }
  })
  cascade = Sound('Kubbi - Ember - 04 Cascade.ogg', {
    tags = {
      music
    }
  })
  fat_font = Font('FatPixelFont', 8)
  game_canvas = Canvas(gw, gh)
  shadow_canvas = Canvas(gw, gh)
  shadow_shader = Shader(nil, 'shadow.frag')
  return start()
end
start = function()
  cascade_instance = cascade:play({
    volume = 0.75,
    loop = true
  })
  bg = Group(camera)
  main = Group(camera):set_as_physics_world(32, 0, 128, {
    'player',
    'enemy'
  })
  effects = Group(camera)
  ui = Group()
  main:disable_collision_between('player', 'player')
  main:disable_collision_between('enemy', 'enemy')
  aw = 2 * gw / 3
  ax1, ax2 = gw / 2 - gw / 3, gw / 2 + gw / 3
  Wall(main, 0, 0, {
    vertices = {
      -40,
      -100000,
      ax1,
      -100000,
      ax1,
      gh + 40,
      -40,
      gh + 40
    },
    color = bg2
  })
  Wall(main, 0, 0, {
    vertices = {
      ax2,
      -100000,
      gw + 40,
      -100000,
      gw + 40,
      gh + 40,
      ax2,
      gh + 40
    },
    color = bg2
  })
  player = Player(main, gw / 2, gh - 40)
  tutorial = Tutorial(bg, gw / 2, gh / 2 - gh / 4)
  paused = false
end
update = function(dt)
  if input.escape.pressed then
    if not paused then
      timer:tween(0.25, _G, {
        slow_amount = 0
      }, math.linear, (function()
        paused = true
      end), 'pause')
    else
      timer:tween(0.25, _G, {
        slow_amount = 1
      }, math.linear, (function()
        paused = false
      end), 'pause')
    end
  end
  if input.s.pressed then
    if sfx.volume == 0.5 then
      sfx.volume = 0
    elseif sfx.volume == 0 then
      sfx.volume = 0.5
    end
  end
  if input.m.pressed then
    if music.volume == 0.5 then
      music.volume = 0
    elseif music.volume == 0 then
      music.volume = 0.5
    end
  end
  if input.r.pressed and player.dead then
    cascade_instance:stop()
    bg:destroy()
    main:destroy()
    effects:destroy()
    ui:destroy()
    timer:tween(0.25, _G, {
      slow_amount = 1
    }, math.linear)
    start()
  end
  cascade_instance.pitch = math.clamp(slow_amount, 0.05, 1)
  bg:update(dt * slow_amount)
  main:update(dt * slow_amount)
  effects:update(dt * slow_amount)
  return ui:update(dt * slow_amount)
end
draw = function()
  game_canvas:draw_to((function()
    bg:draw()
    main:draw()
    effects:draw()
    ui:draw()
    if tutorial.dead and paused then
      local x, y = gw / 2, gh / 2 - gh / 4
      graphics.print('m1 - launch ball', fat_font, x, y, 0, 0.75, 0.75, fat_font:get_text_width('m1 - launch ball') / 2, fat_font.h / 2, fg3)
      graphics.print('m2 - use ability', fat_font, x, y + 26, 0, 0.75, 0.75, fat_font:get_text_width('m2 - use ability') / 2, fat_font.h / 2, fg3)
      graphics.print('1, 2, 3, 4 - switch paddle', fat_font, x, y + 50, 0, 0.5, 0.5, fat_font:get_text_width('1, 2, 3, 4 - switch paddle') / 2, fat_font.h / 2, fg3)
      graphics.print('s - toggle sfx', fat_font, x, y + 100, 0, 0.5, 0.5, fat_font:get_text_width('s - toggle sfx') / 2, fat_font.h / 2, fg3)
      graphics.print('m - toggle music', fat_font, x, y + 120, 0, 0.5, 0.5, fat_font:get_text_width('m - toggle music') / 2, fat_font.h / 2, fg3)
    end
    if flashing then
      return graphics.rectangle(gw / 2, gh / 2, gw, gh, nil, nil, flash_color)
    end
  end))
  shadow_canvas:draw_to((function()
    graphics.set_color(white)
    shadow_shader:set()
    game_canvas:draw2(0, 0, 0, 1, 1)
    return shadow_shader:unset()
  end))
  shadow_canvas:draw(6, 6, 0, sx, sy)
  return game_canvas:draw(0, 0, 0, sx, sy)
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.hit_spring:update(dt)
      local _list_0 = self.balls
      for _index_0 = 1, #_list_0 do
        local ball = _list_0[_index_0]
        ball.spring:update(dt)
      end
      self.score_spring:update(dt)
      self.hp_spring:update(dt)
      self.ball_spring:update(dt)
      self.burst_spring:update(dt)
      if self.red_beam then
        self.red_beam:_update(dt)
      end
      local _list_1 = self.characters
      for _index_0 = 1, #_list_1 do
        local character = _list_1[_index_0]
        character.spring:update(dt)
      end
      if self.dying then
        return 
      end
      local movement_lerp_value = 0.1
      local _exp_0 = self.character_index
      if 1 == _exp_0 then
        movement_lerp_value = 0.1
      elseif 2 == _exp_0 then
        movement_lerp_value = 0.2
      elseif 3 == _exp_0 then
        movement_lerp_value = 0.05
      elseif 4 == _exp_0 then
        movement_lerp_value = 0.05
      end
      self:move_towards_mouse(nil, movement_lerp_value)
      local vx, vy = self:get_velocity()
      self:set_velocity(vx, 0)
      if input.m1.pressed and #self.balls > 0 then
        self:spawn_ball()
      end
      if input['1'].pressed then
        self:switch_character(1)
      end
      if input['2'].pressed then
        self:switch_character(2)
      end
      if input['3'].pressed then
        self:switch_character(3)
      end
      if input['4'].pressed then
        self:switch_character(4)
      end
      local _list_2 = self.characters
      for _index_0 = 1, #_list_2 do
        local character = _list_2[_index_0]
        character.special_timer = character.special_timer + dt
        if character.special_timer > character.special_cd then
          character.special_timer = 0
          character.can_use_special = true
        end
      end
      local character = self.characters[self.character_index]
      if input.m2.pressed and character.can_use_special then
        character.special_timer = 0
        character.can_use_special = false
        local _exp_1 = self.character_index
        if 1 == _exp_1 then
          red1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.5
          })
          red2:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.5
          })
          self.red_beam = red3:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.4,
            loop = true
          })
          StasisArea(main, self.x, gh / 2)
          character.spring:pull(0.25)
          camera:spring_shake(10, math.pi / 2)
        elseif 2 == _exp_1 then
          yellow1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.5
          })
          Clone(main, self.x, self.y, {
            w = 128,
            color = self.characters[self.character_index].color
          })
          character.spring:pull(0.25)
          camera:spring_shake(10, math.pi / 2)
        elseif 3 == _exp_1 then
          green1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.5
          })
          Clone(main, self.x, self.y, {
            w = 32,
            seeker = true,
            color = self.characters[self.character_index].color
          })
          Clone(main, self.x, self.y, {
            w = 32,
            seeker = true,
            color = self.characters[self.character_index].color
          })
          character.spring:pull(0.25)
          camera:spring_shake(5, math.pi / 2)
        elseif 4 == _exp_1 then
          blue1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.75
          })
          StickyWalls(effects, gw / 2, gh / 2)
          self.sticky_walls = true
          self.timer:after(5, (function()
            self.sticky_walls = false
            local balls = self.group:get_objects_by_class(Ball)
            for _index_0 = 1, #balls do
              local ball = balls[_index_0]
              if ball.stuck then
                ball.stuck = false
                ball:set_gravity_scale(1)
                if ball.x > gw / 2 then
                  ball:apply_impulse(random:float(-15, 0), random:float(-5, -10))
                elseif ball.x < gw / 2 then
                  ball:apply_impulse(random:float(0, 15), random:float(-5, -10))
                end
              end
            end
          end))
          character.spring:pull(0.25)
          camera:spring_shake(10, 0)
        end
      end
      self.position_vx = self.x - self.previous_x
      local hd = math.remap(math.abs(self.x - gw / 2), 0, aw / 2, 1, 0)
      camera.x = camera.x + (math.remap(self.position_vx, -10, 10, -48 * hd, 48 * hd) * dt)
      if self.position_vx <= -4 then
        camera.r = math.lerp_angle(0.1, camera.r, -math.pi / 128)
      elseif self.position_vx >= 4 then
        camera.r = math.lerp_angle(0.1, camera.r, math.pi / 128)
      else
        camera.r = math.lerp_angle(0.05, camera.r, 0)
      end
      self.previous_x = self.x
    end,
    draw = function(self)
      local color = self.color
      if self.hit_flash then
        color = fg1
      end
      graphics.push(self.x, self.y, 0, self.hit_spring.x, self.hit_spring.x)
      graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, 4, 4, color)
      graphics.pop()
      local x, y = gw - 60, gh - 14
      local b1, b2 = 0, 0
      if self.burst_shake then
        b1, b2 = random:float(-self.burst_shake, self.burst_shake), random:float(-self.burst_shake, self.burst_shake)
      end
      if self.burst_timer then
        color = red
        if self.burst_hit_flash then
          color = fg1
        end
        graphics.print(tostring(self.burst_timer), fat_font, gw - 38 + b1, gh - 36 + b2, 0, self.burst_spring.x, self.burst_spring.x, fat_font:get_text_width(tostring(self.burst_timer)) / 2, fat_font.h / 2, color)
      else
        graphics.push(gw - 66 + fat_font:get_text_width('balls') / 2, gh - 44 + fat_font.h / 4, 0, self.ball_spring.x, self.ball_spring.x)
        graphics.print('balls' .. string.rep('.', self.ball_ticker), fat_font, gw - 66, gh - 44, 0, 0.6, 0.6, nil, nil, fg1)
        graphics.pop()
      end
      for i, ball in ipairs(self.balls) do
        b1, b2 = 0, 0
        if self.burst_shake then
          b1, b2 = random:float(-self.burst_shake, self.burst_shake), random:float(-self.burst_shake, self.burst_shake)
        end
        graphics.circle(x + 4 + (i - 1) * 16 + b1, y + b2, 4 * ball.spring.x, ball.color)
      end
      graphics.print('score', fat_font, gw - 65, 14, 0, 0.6, 0.6, nil, nil, fg1)
      local score_color = yellow
      if self.score_hit_flash then
        score_color = fg1
      end
      graphics.push(gw - 40, 32 + fat_font.h / 3, 0, self.score_spring.x, self.score_spring.x)
      graphics.print(tostring(self.score), fat_font, gw - 40 - fat_font:get_text_width(tostring(self.score)) / 2, 32, 0, 0.75, 0.75, nil, nil, score_color)
      graphics.pop()
      local hp_color = self.characters[self.character_index].color
      if self.hp_hit_flash then
        hp_color = fg1
      end
      graphics.print('hp', fat_font, 8, 18, -math.pi / 8, 0.6 * self.hp_spring.x, 0.6 * self.hp_spring.x, nil, nil, hp_color)
      for i = 1, self.max_hp do
        if self.hp >= i then
          graphics.rectangle(36 + (i - 1) * 10, 24, 8 * self.hp_spring.x, 8 * self.hp_spring.x, 2, 2, hp_color)
        else
          graphics.rectangle(36 + (i - 1) * 10, 24, 8 * self.hp_spring.x, 8 * self.hp_spring.x, 2, 2, hp_color, 1)
        end
      end
      for i, character in ipairs(self.characters) do
        local text_color = fg1
        if character.dead then
          text_color = fg2
        end
        graphics.print(i, fat_font, 16, 92 + (i - 1) * 20, 0, 0.6 * character.spring.x, 0.6 * character.spring.x, nil, nil, text_color)
        color = character.color
        if character.dead then
          color = fg2
        end
        if character.can_use_special then
          graphics.rectangle(36, 100 + (i - 1) * 20, 8 * character.spring.x, 8 * character.spring.x, 2, 2, color)
          graphics.rectangle(36, 100 + (i - 1) * 20, 8 * character.spring.x, 8 * character.spring.x, 2, 2, color, 2)
        elseif not character.can_use_special or character.dead then
          graphics.rectangle(36, 100 + (i - 1) * 20, 8 * character.spring.x, 8 * character.spring.x, 2, 2, color, 2)
        end
        for j = 1, character.max_hp do
          graphics.rectangle(48 + (j - 1) * 8, 100 + (i - 1) * 20, 5 * self.hp_spring.x, 5 * self.hp_spring.x, 1, 1, color, 1)
        end
        if not character.dead then
          for j = 1, character.hp do
            graphics.rectangle(48 + (j - 1) * 8, 100 + (i - 1) * 20, 5 * self.hp_spring.x, 5 * self.hp_spring.x, 1, 1, color)
          end
        end
      end
    end,
    on_collision_enter = function(self, other, contact)
      if other.__class == Wall then
        local intensity = math.remap(math.abs(self.position_vx), 0, 20, 0, 1)
        self.hit_spring:pull(0.25 * intensity)
        camera:shake(2 * intensity, 0.25 * intensity)
        local x, y = contact:getPositions()
        for i = 1, 4 do
          local r = 0
          if math.sign(self.position_vx) == -1 then
            r = random:float(-math.pi / 2.5, math.pi / 2.5)
          elseif math.sign(self.position_vx) == 1 then
            r = random:float(math.pi - math.pi / 2.5, math.pi + math.pi / 2.5)
          end
          HitParticle(effects, x, self.y, {
            v = random:float(50, 150) * intensity,
            r = r,
            color = self.color,
            duration = random:float(0.2, 0.4) * intensity
          })
        end
        do
          local _with_0 = HitCircle(effects, x, self.y, {
            color = fg1
          })
          _with_0:scale_down(0.2)
          _with_0:change_color(0.25, self.color)
        end
        return hit1:play({
          pitch = random:float(0.95, 1.05),
          volume = intensity * 0.35
        })
      end
    end,
    hit = function(self)
      self.hit_spring:pull(0.15)
      self.hit_flash = true
      self.timer:after(0.15, (function()
        self.hit_flash = false
      end), 'hit_flash')
      return camera:spring_shake(3, math.pi / 2)
    end,
    add_character = function(self, character)
      return table.insert(self.characters, character)
    end,
    switch_character = function(self, character_index)
      if self.characters[character_index].dead then
        error1:play({
          pitch = random:float(0.95, 1.05),
          volume = 0.5
        })
        return 
      end
      switch1:play({
        pitch = random:float(0.95, 1.05),
        volume = 0.5
      })
      wind1:play({
        pitch = random:float(0.95, 1.05),
        volume = 0.5
      })
      self.character_index = character_index
      self.hp_spring:pull(0.15, 200, 10)
      RefreshEffect(effects, self.x, self.y, {
        parent = self,
        w = 1.2 * self.shape.w,
        h = 3 * self.shape.h
      })
      do
        local _with_0 = self.characters[character_index]
        self.hp = _with_0.hp
        self.max_hp = _with_0.max_hp
        self.color = _with_0.color
        self.special_cd = _with_0.special_cd
        self.special = _with_0.special
        return _with_0
      end
    end,
    add_ball = function(self)
      local ball = {
        color = red,
        spring = Spring(1)
      }
      ball.spring:pull(0.5)
      return table.insert(self.balls, ball)
    end,
    spawn_ball = function(self)
      shoot1:play({
        pitch = random:float(0.95, 1.05),
        volume = 0.5
      })
      local ball = table.remove(self.balls, 1)
      SpawnBall(effects, self.x, self.y - 8, {
        color = ball.color
      })
      local _list_0 = self.balls
      for _index_0 = 1, #_list_0 do
        local ball = _list_0[_index_0]
        ball.spring:pull(0.25)
      end
      self.timer:cancel('ball_limit')
      self.timer:cancel('ball_limit_1')
      self.timer:cancel('ball_limit_2')
      self.timer:cancel('ball_limit_3')
      self.burst_timer = nil
      self.burst_shake = 0
    end,
    add_score = function(self)
      self.score = self.score + 1
      self.chained_score = self.chained_score + 1
      self.score_spring:pull(0.5)
      self.score_hit_flash = true
      self.timer:after(0.15, (function()
        self.score_hit_flash = false
      end), 'score_hit_flash')
      return BumpInfoText(effects, self.x, self.y + 12, {
        color = fg1,
        text = '+' .. tostring(self.chained_score),
        duration_multiplier = 0.5,
        size_multiplier = 0.9
      })
    end,
    miss = function(self, x)
      if x == nil then
        x = self.x
      end
      hit3:play({
        pitch = random:float(0.95, 1.05),
        volume = 0.5
      })
      self.chained_score = 0
      self.score_spring:pull(0.5)
      BumpInfoText(effects, x, gh, {
        color = red,
        text = 'miss..',
        vertical_multiplier = -1
      })
      slow(0.5, 0.5)
      camera:shake(5, 0.5)
      return self:change_hp(-1)
    end,
    change_hp = function(self, n)
      if n == nil then
        n = 1
      end
      self.hp = self.hp + n
      self.characters[self.character_index].hp = self.hp
      self.hp_spring:pull(0.5)
      self.score_hit_flash = true
      self.hp_hit_flash = true
      self.timer:after(0.15, (function()
        self.hp_hit_flash = false
      end), 'hp_hit_flash')
      if self.hp <= 0 then
        slow(0.25, 0.5)
        self.characters[self.character_index].dead = true
        if not self.characters[1].dead then
          self:switch_character(1)
          return 
        end
        if not self.characters[2].dead then
          self:switch_character(2)
          return 
        end
        if not self.characters[3].dead then
          self:switch_character(3)
          return 
        end
        if not self.characters[4].dead then
          self:switch_character(4)
          return 
        end
        self.dead = true
        do
          local _with_0 = HitCircle(effects, self.x, self.y, {
            color = fg1
          })
          _with_0:scale_down(0.5)
          _with_0:change_color(0.3, self.characters[self.character_index].color)
        end
        for i = 1, 8 do
          HitParticle(effects, self.x, self.y, {
            color = self.characters[self.character_index].color,
            v = random:float(100, 200),
            duration = random:float(0.2, 1)
          })
        end
        timer:after(0.5, (function()
          return Score(effects, gw / 2, gh / 2, {
            score = self.score
          })
        end))
        local balls = self.group:get_objects_by_class(Ball)
        for _index_0 = 1, #balls do
          local ball = balls[_index_0]
          ball:die()
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self:set_as_rectangle(48, 8, 'dynamic', 'player')
      self:set_gravity_scale(0)
      self:set_fixed_rotation(true)
      self.color = river
      self.previous_x = self.x
      self.position_vx = 0
      self.hit_spring = Spring(1, 200, 20)
      self.balls = { }
      for i = 1, 3 do
        self:add_ball()
      end
      self.timer:every(5, (function()
        if #self.balls < 3 then
          self:add_ball()
          if #self.balls == 3 then
            return self.timer:after(5, (function()
              self.burst_timer = 3
              self.burst_spring:pull(0.5, 200, 10)
              self.burst_hit_flash = true
              self.burst_shake = 0.5
              self.timer:after(0.15, (function()
                self.burst_hit_flash = false
              end), 'burst_hit_flash')
              alert1:play({
                volume = 0.5
              })
              return self.timer:after(1, (function()
                self.burst_timer = 2
                self.burst_spring:pull(0.5, 200, 10)
                self.burst_hit_flash = true
                self.burst_shake = 1
                self.timer:after(0.15, (function()
                  self.burst_hit_flash = false
                end), 'burst_hit_flash')
                alert1:play({
                  volume = 0.5
                })
                return self.timer:after(1, (function()
                  self.burst_timer = 1
                  self.burst_spring:pull(0.5, 200, 10)
                  self.burst_hit_flash = true
                  self.burst_shake = 2
                  self.timer:after(0.15, (function()
                    self.burst_hit_flash = false
                  end), 'burst_hit_flash')
                  alert1:play({
                    volume = 0.5
                  })
                  return self.timer:after(1, (function()
                    alert1:play({
                      pitch = 1.2,
                      volume = 0.5
                    })
                    local vxs = table.shuffle({
                      -100,
                      0,
                      100
                    })
                    local vys = table.shuffle({
                      -170,
                      -200,
                      -230
                    })
                    for i = 1, 3 do
                      SpawnBall(effects, self.x, self.y - 8, {
                        color = self.balls[i].color,
                        vx = vxs[i],
                        vy = vys[i]
                      })
                    end
                    self.balls = { }
                    self.burst_timer = nil
                    self.burst_shake = nil
                    camera:shake(4, 0.25)
                    slow(0.5, 0.25)
                    hit3:play({
                      pitch = random:float(0.95, 1.05),
                      volume = 0.5
                    })
                    hit2:play({
                      pitch = random:float(0.95, 1.05),
                      volume = 0.5
                    })
                    return self.ball_spring:pull(1)
                  end), 'ball_limit_3')
                end), 'ball_limit_2')
              end), 'ball_limit_1')
            end), 'ball_limit')
          end
        end
      end))
      self.score = 0
      self.chained_score = 0
      self.score_spring = Spring(1)
      self.hp_spring = Spring(1)
      self.ball_spring = Spring(1)
      self.burst_spring = Spring(1)
      self.ball_ticker = 0
      self.timer:every(0.75, (function()
        self.ball_spring:pull(0.05)
        self.ball_ticker = self.ball_ticker + 1
        if self.ball_ticker > 2 then
          self.ball_ticker = 0
        end
      end))
      self.characters = { }
      self:add_character({
        max_hp = 3,
        hp = 3,
        color = red,
        special = 'statis_area',
        special_cd = 10,
        special_timer = 0,
        can_use_special = true,
        spring = Spring(1)
      })
      self:add_character({
        max_hp = 4,
        hp = 4,
        color = yellow,
        special = 'static_clone',
        special_cd = 20,
        special_timer = 0,
        can_use_special = true,
        spring = Spring(1)
      })
      self:add_character({
        max_hp = 2,
        hp = 2,
        color = green,
        special = 'auto_clone',
        special_cd = 20,
        special_timer = 0,
        can_use_special = true,
        spring = Spring(1)
      })
      self:add_character({
        max_hp = 2,
        hp = 2,
        color = blue,
        special = 'sticky_walls',
        special_cd = 10,
        special_timer = 0,
        can_use_special = true,
        spring = Spring(1)
      })
      return self:switch_character(1)
    end,
    __base = _base_0,
    __name = "Player",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Player = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      return self:update_game_object(dt)
    end,
    draw = function(self)
      local _ = [[    -- logo
    graphics.print 'JUGGLRX', fat_font, @x, @y, 0, 1, 1, fat_font\get_text_width'JUGGLRX'/2, fat_font.h/2, fg1
    graphics.circle @x + 56, @y - 6, 4, green
    graphics.circle @x + 16, @y - 22, 4, blue
    graphics.circle @x - 11, @y + 9, 4, red
    graphics.circle @x - 32, @y - 24, 4, yellow
    graphics.circle @x - 56, @y - 8, 4, orange
    ]]
      graphics.print('m1 - launch ball', fat_font, self.x, self.y, 0, 0.75, 0.75, fat_font:get_text_width('m1 - launch ball') / 2, fat_font.h / 2, self.color)
      graphics.print('m2 - use ability', fat_font, self.x, self.y + 26, 0, 0.75, 0.75, fat_font:get_text_width('m2 - use ability') / 2, fat_font.h / 2, self.color)
      graphics.print('1, 2, 3, 4 - switch paddle', fat_font, self.x, self.y + 50, 0, 0.5, 0.5, fat_font:get_text_width('1, 2, 3, 4 - switch paddle') / 2, fat_font.h / 2, self.color)
      graphics.print('s - toggle sfx', fat_font, self.x, self.y + 100, 0, 0.5, 0.5, fat_font:get_text_width('s - toggle sfx') / 2, fat_font.h / 2, self.color)
      return graphics.print('m - toggle music', fat_font, self.x, self.y + 120, 0, 0.5, 0.5, fat_font:get_text_width('m - toggle music') / 2, fat_font.h / 2, self.color)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.color = fg3:clone()
      return self.timer:after(15, (function()
        return self.timer:tween(0.25, self.color, {
          a = 0
        }, math.linear, (function()
          self.dead = true
        end))
      end))
    end,
    __base = _base_0,
    __name = "Tutorial",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Tutorial = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      return self.spring:update(dt)
    end,
    draw = function(self)
      graphics.line(ax1, gh + 40, ax1, -40, blue, self.w * self.spring.x)
      return graphics.line(ax2, gh + 40, ax2, -40, blue, self.w * self.spring.x)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.spring = Spring(1)
      self.w = 0
      self.timer:tween(0.05, self, {
        w = 5
      }, math.linear, (function()
        return self.spring:pull(0.25)
      end))
      return self.timer:after(5, (function()
        return self.timer:tween(0.05, self, {
          w = 0
        }, math.linear, (function()
          self.dead = true
          return blue2:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.5
          })
        end))
      end))
    end,
    __base = _base_0,
    __name = "StickyWalls",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  StickyWalls = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.hit_spring:update(dt)
      if self.seeker then
        if self.ball and self.ball.dead then
          self.ball = nil
          self:die()
        end
        if self.ball then
          self:move_towards_object(self.ball, nil, 0.02)
          local vx, vy = self:get_velocity()
          return self:set_velocity(vx, 0)
        end
      end
    end,
    draw = function(self)
      local color = self.color
      if self.hit_flash then
        color = fg1
      end
      graphics.push(self.x, self.y, 0, self.hit_spring.x, self.hit_spring.x)
      graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, 4, 4, color)
      graphics.pop()
      if self.ball then
        return graphics.dashed_rounded_line(self.x - 1.5, self.y - 12, self.ball.x - 1.5, self.ball.y + 12, 8, 8, color, 6)
      end
    end,
    hit = function(self)
      self.hit_spring:pull(0.15)
      self.hit_flash = true
      self.timer:after(0.15, (function()
        self.hit_flash = false
      end), 'hit_flash')
      return camera:spring_shake(2, math.pi / 2)
    end,
    die = function(self)
      do
        local _with_0 = HitCircle(effects, self.x, self.y, {
          color = fg1
        })
        _with_0:scale_down(0.5)
        _with_0:change_color(0.3, self.color)
      end
      for i = 1, 8 do
        HitParticle(effects, self.x, self.y, {
          color = self.color,
          v = random:float(100, 200),
          duration = random:float(0.2, 1)
        })
      end
      self.dead = true
      if self.seeker and self.ball then
        self.ball.taken = false
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self:set_as_rectangle(self.w, 8, 'dynamic', 'player')
      self:set_gravity_scale(0)
      self:set_fixed_rotation(true)
      RefreshEffect(effects, self.x, self.y, {
        parent = self,
        w = 1.2 * self.shape.w,
        h = 3 * self.shape.h
      })
      self.hit_spring = Spring(1)
      self.timer:after(10, (function()
        return self:die()
      end))
      if self.seeker then
        return self.timer:every_immediate(0.5, (function()
          local runs = 0
          while not self.ball and runs < 50 do
            local balls = self.group:get_objects_by_class(Ball)
            local ball = random:table(balls)
            if ball and not ball.taken and not ball.dead then
              ball.taken = true
              self.ball = ball
            end
            runs = runs + 1
          end
        end))
      end
    end,
    __base = _base_0,
    __name = "Clone",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Clone = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      return self.spring:update(dt)
    end,
    draw = function(self)
      graphics.push(self.x, self.y, 0, self.spring.x, self.spring.x)
      graphics.rectangle(self.x, self.y, self.wm * self.shape.w, self.shape.h, nil, nil, self.color)
      if self.wm >= 1 then
        graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, nil, nil, red, 2)
      end
      graphics.pop()
      if self.wm < 1 then
        graphics.line(self.x + self.spring.x * self.wm * self.shape.w / 2, self.y + self.shape.h / 2, self.x + self.spring.x * self.wm * self.shape.w / 2, self.y - self.shape.h / 2, red, 2)
        return graphics.line(self.x - self.spring.x * self.wm * self.shape.w / 2, self.y + self.shape.h / 2, self.x - self.spring.x * self.wm * self.shape.w / 2, self.y - self.shape.h / 2, red, 2)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.shape = Rectangle(self.x, self.y, gw / 4, 1.2 * gh)
      self.color = Color(red.r, red.g, red.b, 0.25)
      self.spring = Spring(1)
      self.wm = 1
      self.timer:every_immediate(1, (function()
        return self.spring:pull(0.05)
      end))
      self.timer:every(0.15, (function()
        return StasisParticle(effects, random:float(self.x - 0.4 * self.shape.w, self.x + 0.4 * self.shape.w), random:float(self.y - 0.4 * self.shape.h, self.y + 0.4 * self.shape.h))
      end))
      return self.timer:after(5, (function()
        player.red_beam:pause(0.5)
        red4:play({
          pitch = random:float(0.95, 1.05),
          volume = 0.5
        })
        return self.timer:tween(0.5, self, {
          wm = 0
        }, math.cubic_in_out, (function()
          self.dead = true
          player.red_beam = nil
        end))
      end))
    end,
    __base = _base_0,
    __name = "StasisArea",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  StasisArea = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.y = self.y - (self.v * dt)
    end,
    draw = function(self)
      return graphics.rectangle(self.x, self.y, self.w, self.h, 2, 2, red)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.v = 0
      self.h = 0
      self.w = 4
      return self.timer:tween(0.03, self, {
        h = random:float(8, 16),
        v = random:float(0, 50)
      }, math.linear, (function()
        return self.timer:after(random:float(0.2, 0.6), (function()
          return self.timer:tween(random:float(0.1, 0.2), self, {
            w = 0,
            h = 0
          }, math.linear, (function()
            self.dead = true
          end))
        end))
      end))
    end,
    __base = _base_0,
    __name = "StasisParticle",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  StasisParticle = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.hit_spring:update(dt)
      local vx, vy = self:get_velocity()
      self:set_velocity(vx, math.clamp(vy, -500, 500) - self.ay * dt)
      local stasis_areas = self.group:get_objects_by_class(StasisArea)
      for _index_0 = 1, #stasis_areas do
        local sa = stasis_areas[_index_0]
        if self:is_colliding_with_shape(sa.shape) then
          self:set_gravity_scale(0)
          self:set_damping(2)
          self.in_stasis_area = true
        else
          self:set_gravity_scale(1)
          self:set_damping(0)
          self.in_stasis_area = false
        end
      end
      if #stasis_areas <= 0 then
        self.in_stasis_area = false
      end
      if not self.in_stasis_area and self.previous_in_stasis_area then
        self:set_gravity_scale(1)
        self:set_damping(0)
        self:apply_impulse(random:float(-5, 5), -5)
      end
      self.previous_in_stasis_area = self.in_stasis_area
      if self.y > gh + 40 then
        self:die()
        return player:miss(self.x)
      end
    end,
    draw = function(self)
      local color = self.color
      if self.hit_flash then
        color = fg1
      end
      return graphics.circle(self.x, self.y, self.shape.rs * self.hit_spring.x, color)
    end,
    on_collision_enter = function(self, other, contact)
      if other.__class == Player or other.__class == Clone then
        local x, y = contact:getPositions()
        local vx, vy = self:get_velocity()
        local distance_from_center = math.abs(other.x - self.x)
        local direction_of_impulse = math.sign(self.x - other.x)
        if not self.vy and not self.just_spawned then
          vy = -230
          if self.color == red then
            vy = -230
          end
          if distance_from_center < other.shape.w / 8 then
            self:set_velocity(vx / 2, vy)
          elseif distance_from_center >= other.shape.w / 8 then
            self:set_velocity(50 * math.sign(self.x - other.x) * math.remap(math.abs(other.x - self.x), 0, other.shape.w / 2, 0, 4), vy)
          end
          hit4:play({
            pitch = random:float(0.9, 1.1),
            volume = 0.4
          })
          pop1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.3
          })
        end
        self:hit()
        other:hit()
        for i = 1, 4 do
          HitParticle(effects, x, y, {
            v = random:float(100, 150),
            r = random:float(-3 * math.pi / 4, -math.pi / 4),
            color = self.color,
            duration = random:float(0.2, 0.4)
          })
        end
        return player:add_score()
      elseif other.__class == Wall then
        local x, y = contact:getPositions()
        local vx, vy = self:get_velocity()
        if player.sticky_walls then
          self.stuck = true
          self:set_velocity(0, 0)
          self:set_gravity_scale(0)
          local r = 0
          if self.x > gw / 2 then
            r = random:float(math.pi - math.pi / 2.5, math.pi + math.pi / 2.5)
          elseif self.x < gw / 2 then
            r = random:float(-math.pi / 2.5, math.pi / 2.5)
          end
          for i = 1, 3 do
            HitParticle(effects, x, y, {
              v = random:float(100, 200),
              r = r,
              color = blue,
              duration = random:float(0.2, 0.4),
              w = random:float(5, 8)
            })
          end
          return random:table({
            stick1,
            stick2
          }):play({
            pitch = random:float(0.95, 1.05),
            volume = 0.25
          })
        else
          self:set_velocity(-vx, vy)
          self.hit_spring:pull(0.15)
          local r = 0
          if self.x > gw / 2 then
            r = random:float(math.pi - math.pi / 2.5, math.pi + math.pi / 2.5)
          elseif self.x < gw / 2 then
            r = random:float(-math.pi / 2.5, math.pi / 2.5)
          end
          for i = 1, 2 do
            HitParticle(effects, x, y, {
              v = random:float(50, 150),
              r = r,
              color = red,
              duration = random:float(0.2, 0.4)
            })
          end
          return hit1:play({
            pitch = random:float(0.95, 1.05),
            volume = 0.05
          })
        end
      end
    end,
    hit = function(self, m)
      if m == nil then
        m = 1
      end
      self.hit_spring:pull(m * 0.25)
      self.hit_flash = true
      return self.timer:after(0.1, (function()
        self.hit_flash = false
      end), 'hit_flash')
    end,
    die = function(self)
      self.dead = true
      do
        local _with_0 = HitCircle(effects, self.x, self.y, {
          color = fg1
        })
        _with_0:scale_down(0.2)
        _with_0:change_color(0.25, self.color)
      end
      for i = 1, 4 do
        HitParticle(effects, self.x, self.y, {
          color = self.color,
          v = random:float(100, 150)
        })
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self:set_as_circle(4.5, 'dynamic', 'enemy')
      self:set_fixed_rotation(true)
      self.hit_spring = Spring(1)
      self.color = red
      if self.vx and self.vy then
        self:set_velocity(self.vx, self.vy)
      else
        self:set_velocity(0, -230)
      end
      self.bounces = 0
      self.just_spawned = true
      self.timer:after(0.05, (function()
        self.just_spawned = false
        self.vy = false
      end))
      self._vy = 0
      self.ay = 0
      self.in_stasis_area = false
    end,
    __base = _base_0,
    __name = "Ball",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Ball = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.text_object:update(dt)
      return self.spring:update(dt)
    end,
    draw = function(self)
      graphics.push(self.x, self.y, 0, self.sx * self.spring.x, self.sy * self.spring.x)
      self.text_object:draw(self.x - fat_font:get_text_width(self.text_object.raw_text) / 2, self.y - fat_font:get_height() / 2)
      return graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.text_object = Text('[wavy][color]' .. self.text, {
        wavy = TextTag({
          update = (function(c, dt, i, text)
            c.oy = 8 * math.sin(2 * time + i)
          end)
        }),
        color = TextTag({
          init = (function(c, i, text)
            c.color = fg1
            return self.timer:after(0.15, (function()
              c.color = self.color
            end))
          end),
          draw = (function(c, i, text)
            return graphics.set_color(c.color)
          end)
        })
      }, fat_font)
      self.sx, self.sy = 0.5 * (self.size_multiplier or 1), 0.5 * (self.size_multiplier or 1)
      self.spring = Spring(1)
      self.spring:pull(0.5)
      return self.timer:tween(1 * (self.duration_multiplier or 1), self, {
        y = self.y + 20 * (self.vertical_multiplier or 1)
      }, math.expo_out, (function()
        return self.timer:tween(0.05, self, {
          sx = 0,
          sy = 0
        }, math.linear, (function()
          self.dead = true
        end))
      end))
    end,
    __base = _base_0,
    __name = "BumpInfoText",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  BumpInfoText = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      local _base_1 = self.text
      local _fn_0 = _base_1.update
      return function(...)
        return _fn_0(_base_1, ...)
      end
    end,
    draw = function(self)
      self.text:draw(self.x - self.text.font:get_text_width(self.text.raw_text) / 2, self.y - self.text.font.h / 2)
      if self.restart then
        return graphics.print('r - restart', fat_font, self.x, self.y + 32, 0, 0.75, 0.75, fat_font:get_text_width('r - restart') / 2, fat_font.h / 2, fg3)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      local invisible = Color(1, 1, 1, 0)
      self.text = Text('[cbyc]score: ' .. self.score, {
        cbyc = TextTag({
          init = (function(c, i, text)
            c.color = invisible
            return timer:after((i - 1) * 0.2, (function()
              c.color = fg1
              camera:shake(3, 0.12)
              return hit1:play({
                pitch = random:float(0.95, 1.05),
                volume = 0.35
              })
            end))
          end),
          draw = (function(c, i, text)
            return graphics.set_color(c.color)
          end)
        })
      }, fat_font)
      self.restart = true
      return self.timer:tween(1, _G, {
        slow_amount = 0
      }, math.linear)
    end,
    __base = _base_0,
    __name = "Score",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Score = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      return self.spring:update(dt)
    end,
    draw = function(self)
      return graphics.circle(self.x, self.y, self.rs * self.spring.x, self.color)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.target_color = self.color or red
      self.color = fg1
      self.rs = 6
      self.spring = Spring(1)
      self.spring:pull(1)
      for i = 1, random:int(6, 8) do
        HitParticle(effects, self.x, self.y, {
          color = self.target_color,
          duration = random:float(0.3, 0.5),
          w = random:float(5, 8),
          v = random:float(150, 200)
        })
      end
      Ball(main, self.x, self.y, {
        vx = self.vx,
        vy = self.vy
      })
      self.timer:tween(0.25, self, {
        rs = 0
      }, math.linear, (function()
        self.dead = true
      end))
      return self.timer:after(0.15, (function()
        self.color = self.target_color
      end))
    end,
    __base = _base_0,
    __name = "SpawnBall",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SpawnBall = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      if self.parent and self.parent.dead then
        self.parent = nil
        self.dead = true
        return 
      end
      self.x, self.y = self.parent.x, self.parent.y
      self.r = self.parent.r
    end,
    draw = function(self)
      graphics.push(self.x, self.y, self.r)
      graphics.set_color(fg1)
      love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.oy, self.w, self.h)
      return graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.oy = self.h / 3
      return self.timer:tween(0.15, self, {
        h = 0
      }, math.linear, (function()
        self.dead = true
      end))
    end,
    __base = _base_0,
    __name = "RefreshEffect",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  RefreshEffect = _class_0
end
slow = function(amount, duration, tween_method)
  if amount == nil then
    amount = 0.5
  end
  if duration == nil then
    duration = 0.5
  end
  if tween_method == nil then
    tween_method = math.cubic_in_out
  end
  slow_amount = amount
  return timer:tween(duration, _G, {
    slow_amount = 1
  }, tween_method, (function()
    slow_amount = 1
  end), 'slow')
end
flash = function(duration, color)
  if duration == nil then
    duration = 0.05
  end
  if color == nil then
    color = fg1
  end
  flashing = true
  flash_color = color
  return timer:after(duration, (function()
    flashing = false
  end), 'flash')
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      return self:update_game_object(dt)
    end,
    draw = function(self)
      return graphics.circle(self.x, self.y, self.rs, self.color)
    end,
    scale_down = function(self, duration)
      if duration == nil then
        duration = 0.2
      end
      self.duration = duration
      self.timer:cancel('die')
      return self.timer:tween(self.duration, self, {
        rs = 0
      }, math.cubic_in_out, (function()
        self.dead = true
      end))
    end,
    change_color = function(self, delay_multiplier, target_color)
      if delay_multiplier == nil then
        delay_multiplier = 0.5
      end
      return self.timer:after(delay_multiplier * self.duration, (function()
        self.color = target_color
      end))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.rs = self.rs or 8
      self.duration = self.duration or 0.05
      self.color = self.color or white
      return self.timer:after(self.duration, (function()
        self.dead = true
      end), 'die')
    end,
    __base = _base_0,
    __name = "HitCircle",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  HitCircle = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.x = self.x + (self.v * math.cos(self.r) * dt)
      self.y = self.y + (self.v * math.sin(self.r) * dt)
    end,
    draw = function(self)
      graphics.push(self.x, self.y, self.r)
      graphics.rectangle(self.x, self.y, self.w, self.h, 2, 2, self.color)
      return graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.v = self.v or random:float(50, 150)
      self.r = opts.r or random:float(0, 2 * math.pi)
      self.duration = self.duration or random:float(0.2, 0.6)
      self.w = self.w or random:float(3.5, 7)
      self.h = self.h or (self.w / 2)
      self.color = self.color or white
      return self.timer:tween(self.duration, self, {
        w = 2,
        h = 2,
        v = 0
      }, math.cubic_in_out, (function()
        self.dead = true
      end))
    end,
    __base = _base_0,
    __name = "HitParticle",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  HitParticle = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      self:update_game_object(dt)
      self.animation:update(dt)
      if self.linear_movement then
        self.x = self.x + (self.v * math.cos(self.r) * dt)
        self.y = self.y + (self.v * math.sin(self.r) * dt)
      end
    end,
    draw = function(self)
      return self.animation:draw(self.x + (self.ox or 0), self.y + (self.oy or 0), self.r + (self.oa or 0), (self.flip_sx or 1) * self.sx, (self.flip_sy or 1) * self.sy, nil, nil, self.color)
    end,
    set_linear_movement = function(self, v, r)
      self.v, self.r = v, r
      self.linear_movement = true
      local duration = self.animation.size * self.delay
      return self.timer:after(2 * duration / 3, (function()
        return self.timer:tween(duration / 3, self, {
          v = 0
        }, math.cubic_in_out)
      end))
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self.animation = Animation(self.delay, self.frames, 'once', {
        [0] = (function()
          self.dead = true
        end)
      })
      self.color = self.color or white
    end,
    __base = _base_0,
    __name = "AnimationEffect",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  AnimationEffect = _class_0
end
do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      return self:update_game_object(dt)
    end,
    draw = function(self)
      return self.shape:draw(self.color)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, group, x, y, opts)
      _class_0.__parent.__init(self, group, x, y, opts)
      self:set_as_chain(true, self.vertices, 'static', 'solid')
      self.color = self.color or black
    end,
    __base = _base_0,
    __name = "Wall",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Wall = _class_0
end
love.run = function()
  return engine_run({
    moonscript = true,
    game_name = 'JUGGLRX',
    game_width = 480,
    game_height = 270,
    window_width = 480 * 3,
    window_height = 270 * 3,
    line_style = 'rough',
    default_filter = 'nearest',
    init = init,
    update = update,
    draw = draw
  })
end
