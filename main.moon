export *
moonscript = true
require 'engine'


init = ->
  export *

  black = Color 0, 0, 0, 1
  white = Color 1, 1, 1, 1
  bg1 = Color '#303030'
  bg2 = Color '#272727'
  fg1 = Color '#dadada'
  fg2 = Color '#b0a89f'
  fg3 = Color '#606060'
  error1 = Color '#7a4d4e'
  river = Color '#7badc4'
  yellow = Color '#facf00'
  orange = Color '#f07021'
  blue = Color '#019bd6'
  green = Color '#8bbf40'
  green2 = Color '#017866'
  red = Color '#e91d39'
  purple = Color '#8e559e'
  graphics.set_background_color bg1
  graphics.set_color fg1
  input.set_mouse_grabbed true
  slow_amount = 1

  sfx = SoundTag!
  sfx.volume = 0.5
  music = SoundTag!
  music.volume = 0.5
  switch1 = Sound 'Switch.ogg', tags: {sfx}
  wind1 = Sound 'Wind Bolt 20.ogg', tags: {sfx}
  shoot1 = Sound 'Shooting Projectile (Classic) 11.ogg', tags: {sfx}
  hit1 = Sound 'Player Takes Damage 17.ogg', tags: {sfx}
  hit2 = Sound 'Player Takes Damage 2.ogg', tags: {sfx}
  hit3 = Sound 'Kick 16.ogg', tags: {sfx}
  hit4 = Sound 'Wood Heavy 5.ogg', tags: {sfx}
  stick1 = Sound 'Mud footsteps 7.ogg', tags: {sfx}
  stick2 = Sound 'Mud footsteps 9.ogg', tags: {sfx}
  error1 = Sound 'Player Takes Damage 12.ogg', tags: {sfx}
  pop1 = Sound 'Pop sounds 10.ogg', tags: {sfx}
  blue1 = Sound 'Water Bolt 9.ogg', tags: {sfx}
  blue2 = Sound 'Water Bolt 8.ogg', tags: {sfx}
  red1 = Sound 'Buff 11.ogg', tags: {sfx}
  red2 = Sound 'Magical Impact 25.ogg', tags: {sfx}
  red3 = Sound 'Sci Fi Beam 3.ogg', tags: {sfx}
  red4 = Sound 'Magical Swoosh 21.ogg', tags: {sfx}
  yellow1 = Sound 'Magical Impact 6.ogg', tags: {sfx}
  green1 = Sound 'Magical Impact 5.ogg', tags: {sfx}
  alert1 = Sound 'Alert sounds 3.ogg', tags: {sfx}
  cascade = Sound 'Kubbi - Ember - 04 Cascade.ogg', tags: {music}

  fat_font = Font 'FatPixelFont', 8
  game_canvas = Canvas gw, gh
  shadow_canvas = Canvas gw, gh
  shadow_shader = Shader nil, 'shadow.frag'

  start!


start = ->
  export *
  cascade_instance = cascade\play volume: 0.75, loop: true
  bg = Group(camera)
  main = Group(camera)\set_as_physics_world 32, 0, 128, {'player', 'enemy'}
  effects = Group(camera)
  ui = Group!
  main\disable_collision_between 'player', 'player'
  main\disable_collision_between 'enemy', 'enemy'

  aw = 2*gw/3
  ax1, ax2 = gw/2 - gw/3, gw/2 + gw/3
  Wall main, 0, 0, {vertices: {-40, -100000, ax1, -100000, ax1, gh + 40, -40, gh + 40}, color: bg2}
  Wall main, 0, 0, {vertices: {ax2, -100000, gw + 40, -100000, gw + 40, gh + 40, ax2, gh + 40}, color: bg2}
  player = Player main, gw/2, gh - 40
  tutorial = Tutorial bg, gw/2, gh/2 - gh/4
  paused = false


update = (dt) ->
  if input.escape.pressed
    if not paused
      timer\tween 0.25, _G, {slow_amount: 0}, math.linear, (->
        export paused = true
      ), 'pause'
    else
      timer\tween 0.25, _G, {slow_amount: 1}, math.linear, (->
        export paused = false
      ), 'pause'

  if input.s.pressed
    if sfx.volume == 0.5
      sfx.volume = 0
    elseif sfx.volume == 0
      sfx.volume = 0.5
  if input.m.pressed
    if music.volume == 0.5
      music.volume = 0
    elseif music.volume == 0
      music.volume = 0.5

  if input.r.pressed and player.dead
    cascade_instance\stop!
    bg\destroy!
    main\destroy!
    effects\destroy!
    ui\destroy!
    timer\tween 0.25, _G, {slow_amount: 1}, math.linear
    start!

  cascade_instance.pitch = math.clamp(slow_amount, 0.05, 1)
  bg\update dt*slow_amount
  main\update dt*slow_amount
  effects\update dt*slow_amount
  ui\update dt*slow_amount


draw = ->
  game_canvas\draw_to (->
    bg\draw!
    main\draw!
    effects\draw!
    ui\draw!
    if tutorial.dead and paused
      x, y = gw/2, gh/2 - gh/4
      graphics.print 'm1 - launch ball', fat_font, x, y, 0, 0.75, 0.75, fat_font\get_text_width'm1 - launch ball'/2, fat_font.h/2, fg3
      graphics.print 'm2 - use ability', fat_font, x, y + 26, 0, 0.75, 0.75, fat_font\get_text_width'm2 - use ability'/2, fat_font.h/2, fg3
      graphics.print '1, 2, 3, 4 - switch paddle', fat_font, x, y + 50, 0, 0.5, 0.5, fat_font\get_text_width'1, 2, 3, 4 - switch paddle'/2, fat_font.h/2, fg3
      graphics.print 's - toggle sfx', fat_font, x, y + 100, 0, 0.5, 0.5, fat_font\get_text_width's - toggle sfx'/2, fat_font.h/2, fg3
      graphics.print 'm - toggle music', fat_font, x, y + 120, 0, 0.5, 0.5, fat_font\get_text_width'm - toggle music'/2, fat_font.h/2, fg3

    if flashing then graphics.rectangle gw/2, gh/2, gw, gh, nil, nil, flash_color
  )

  shadow_canvas\draw_to (->
    graphics.set_color white
    shadow_shader\set!
    game_canvas\draw2 0, 0, 0, 1, 1
    shadow_shader\unset!
  )

  shadow_canvas\draw 6, 6, 0, sx, sy
  game_canvas\draw 0, 0, 0, sx, sy


class Player extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @\set_as_rectangle 48, 8, 'dynamic', 'player'
    @\set_gravity_scale 0
    @\set_fixed_rotation true

    @color = river
    @previous_x = @x
    @position_vx = 0
    @hit_spring = Spring 1, 200, 20
    @balls = {}
    for i = 1, 3 do @\add_ball!
    @timer\every 5, (->
      if #@balls < 3
        @\add_ball!
        if #@balls == 3
          @timer\after 5, (->
            @burst_timer = 3
            @burst_spring\pull 0.5, 200, 10
            @burst_hit_flash = true
            @burst_shake = 0.5
            @timer\after 0.15, (-> @burst_hit_flash = false), 'burst_hit_flash'
            alert1\play volume: 0.5
            @timer\after 1, (->
              @burst_timer = 2
              @burst_spring\pull 0.5, 200, 10
              @burst_hit_flash = true
              @burst_shake = 1
              @timer\after 0.15, (-> @burst_hit_flash = false), 'burst_hit_flash'
              alert1\play volume: 0.5
              @timer\after 1, (->
                @burst_timer = 1
                @burst_spring\pull 0.5, 200, 10
                @burst_hit_flash = true
                @burst_shake = 2
                @timer\after 0.15, (-> @burst_hit_flash = false), 'burst_hit_flash'
                alert1\play volume: 0.5
                @timer\after 1, (->
                  alert1\play pitch: 1.2, volume: 0.5
                  vxs = table.shuffle {-100, 0, 100}
                  vys = table.shuffle {-170, -200, -230}
                  for i = 1, 3 do SpawnBall effects, @x, @y - 8, {color: @balls[i].color, vx: vxs[i], vy: vys[i]}
                  @balls = {}
                  @burst_timer = nil
                  @burst_shake = nil
                  camera\shake 4, 0.25
                  slow 0.5, 0.25
                  hit3\play pitch: random\float(0.95, 1.05), volume: 0.5
                  hit2\play pitch: random\float(0.95, 1.05), volume: 0.5
                  @ball_spring\pull 1
                ), 'ball_limit_3'
              ), 'ball_limit_2'
            ), 'ball_limit_1'
          ), 'ball_limit'
    )
    @score = 0
    @chained_score = 0
    @score_spring = Spring 1
    @hp_spring = Spring 1
    @ball_spring = Spring 1
    @burst_spring = Spring 1
    @ball_ticker = 0
    @timer\every 0.75, (->
      @ball_spring\pull 0.05
      @ball_ticker += 1
      if @ball_ticker > 2
        @ball_ticker = 0
    )

    @characters = {}
    @\add_character {max_hp: 3, hp: 3, color: red, special: 'statis_area', special_cd: 10, special_timer: 0, can_use_special: true, spring: Spring 1}
    @\add_character {max_hp: 4, hp: 4, color: yellow, special: 'static_clone', special_cd: 20, special_timer: 0, can_use_special: true, spring: Spring 1}
    @\add_character {max_hp: 2, hp: 2, color: green, special: 'auto_clone', special_cd: 20, special_timer: 0, can_use_special: true, spring: Spring 1}
    @\add_character {max_hp: 2, hp: 2, color: blue, special: 'sticky_walls', special_cd: 10, special_timer: 0, can_use_special: true, spring: Spring 1}
    @\switch_character 1

  update: (dt) =>
    @\update_game_object dt
    @hit_spring\update dt
    for ball in *@balls do ball.spring\update dt
    @score_spring\update dt
    @hp_spring\update dt
    @ball_spring\update dt
    @burst_spring\update dt
    if @red_beam then @red_beam\_update dt
    for character in *@characters do character.spring\update dt

    if @dying then return

    movement_lerp_value = 0.1
    switch @character_index
      when 1
        movement_lerp_value = 0.1
      when 2
        movement_lerp_value = 0.2
      when 3
        movement_lerp_value = 0.05
      when 4
        movement_lerp_value = 0.05
    @\move_towards_mouse nil, movement_lerp_value
    vx, vy = @\get_velocity!
    @\set_velocity vx, 0

    if input.m1.pressed and #@balls > 0
      @\spawn_ball!

    if input['1'].pressed then @\switch_character 1
    if input['2'].pressed then @\switch_character 2
    if input['3'].pressed then @\switch_character 3
    if input['4'].pressed then @\switch_character 4

    for character in *@characters
      character.special_timer += dt
      if character.special_timer > character.special_cd
        character.special_timer = 0
        character.can_use_special = true

    character = @characters[@character_index]
    if input.m2.pressed and character.can_use_special
      character.special_timer = 0
      character.can_use_special = false
      switch @character_index
        when 1
          red1\play pitch: random\float(0.95, 1.05), volume: 0.5
          red2\play pitch: random\float(0.95, 1.05), volume: 0.5
          @red_beam = red3\play pitch:random\float(0.95, 1.05), volume: 0.4, loop: true
          StasisArea main, @x, gh/2
          character.spring\pull 0.25
          camera\spring_shake 10, math.pi/2
        when 2
          yellow1\play pitch: random\float(0.95, 1.05), volume: 0.5
          Clone main, @x, @y, {w: 128, color: @characters[@character_index].color}
          character.spring\pull 0.25
          camera\spring_shake 10, math.pi/2
        when 3
          green1\play pitch: random\float(0.95, 1.05), volume: 0.5
          Clone main, @x, @y, {w: 32, seeker: true, color: @characters[@character_index].color}
          Clone main, @x, @y, {w: 32, seeker: true, color: @characters[@character_index].color}
          character.spring\pull 0.25
          camera\spring_shake 5, math.pi/2
        when 4
          blue1\play pitch: random\float(0.95, 1.05), volume: 0.75
          StickyWalls effects, gw/2, gh/2
          @sticky_walls = true
          @timer\after 5, (->
            @sticky_walls = false
            balls = @group\get_objects_by_class Ball
            for ball in *balls
              if ball.stuck
                ball.stuck = false
                ball\set_gravity_scale 1
                if ball.x > gw/2
                  ball\apply_impulse random\float(-15, 0), random\float(-5, -10)
                elseif ball.x < gw/2
                  ball\apply_impulse random\float(0, 15), random\float(-5, -10)
          )
          character.spring\pull 0.25
          camera\spring_shake 10, 0

    @position_vx = @x - @previous_x
    hd = math.remap math.abs(@x - gw/2), 0, aw/2, 1, 0
    camera.x += math.remap(@position_vx, -10, 10, -48*hd, 48*hd)*dt
    if @position_vx <= -4 then camera.r = math.lerp_angle 0.1, camera.r, -math.pi/128
    elseif @position_vx >= 4 then camera.r = math.lerp_angle 0.1, camera.r, math.pi/128
    else camera.r = math.lerp_angle 0.05, camera.r, 0

    @previous_x = @x

  draw: =>
    color = @color
    if @hit_flash then color = fg1
    graphics.push @x, @y, 0, @hit_spring.x, @hit_spring.x
    graphics.rectangle @x, @y, @shape.w, @shape.h, 4, 4, color
    graphics.pop!

    -- Balls
    x, y = gw - 60, gh - 14
    b1, b2 = 0, 0
    if @burst_shake then b1, b2 = random\float(-@burst_shake, @burst_shake), random\float(-@burst_shake, @burst_shake)
    if @burst_timer
      color = red
      if @burst_hit_flash then color = fg1
      graphics.print tostring(@burst_timer), fat_font, gw - 38 + b1, gh - 36 + b2, 0, @burst_spring.x, @burst_spring.x, fat_font\get_text_width(tostring(@burst_timer))/2, fat_font.h/2, color
    else
      graphics.push gw - 66 + fat_font\get_text_width('balls')/2, gh - 44 + fat_font.h/4, 0, @ball_spring.x, @ball_spring.x
      graphics.print 'balls' .. string.rep('.', @ball_ticker), fat_font, gw - 66, gh - 44, 0, 0.6, 0.6, nil, nil, fg1
      graphics.pop!
    for i, ball in ipairs @balls
      b1, b2 = 0, 0
      if @burst_shake then b1, b2 = random\float(-@burst_shake, @burst_shake), random\float(-@burst_shake, @burst_shake)
      graphics.circle x + 4 + (i-1)*16 + b1, y + b2, 4*ball.spring.x, ball.color

    -- Score
    graphics.print 'score', fat_font, gw - 65, 14, 0, 0.6, 0.6, nil, nil, fg1
    score_color = yellow
    if @score_hit_flash then score_color = fg1
    graphics.push gw - 40, 32 + fat_font.h/3, 0, @score_spring.x, @score_spring.x
    graphics.print tostring(@score), fat_font, gw - 40 - fat_font\get_text_width(tostring(@score))/2, 32, 0, 0.75, 0.75, nil, nil, score_color
    graphics.pop!

    -- HP
    hp_color = @characters[@character_index].color
    if @hp_hit_flash then hp_color = fg1
    graphics.print 'hp', fat_font, 8, 18, -math.pi/8, 0.6*@hp_spring.x, 0.6*@hp_spring.x, nil, nil, hp_color
    for i = 1, @max_hp
      if @hp >= i
        graphics.rectangle 36 + (i-1)*10, 24, 8*@hp_spring.x, 8*@hp_spring.x, 2, 2, hp_color
      else
        graphics.rectangle 36 + (i-1)*10, 24, 8*@hp_spring.x, 8*@hp_spring.x, 2, 2, hp_color, 1

    -- Characters
    for i, character in ipairs @characters
      text_color = fg1
      if character.dead then text_color = fg2
      graphics.print i, fat_font, 16, 92 + (i-1)*20, 0, 0.6*character.spring.x, 0.6*character.spring.x, nil, nil, text_color
      color = character.color
      if character.dead then color = fg2
      if character.can_use_special
        graphics.rectangle 36, 100 + (i-1)*20, 8*character.spring.x, 8*character.spring.x, 2, 2, color
        graphics.rectangle 36, 100 + (i-1)*20, 8*character.spring.x, 8*character.spring.x, 2, 2, color, 2
      elseif not character.can_use_special or character.dead
        graphics.rectangle 36, 100 + (i-1)*20, 8*character.spring.x, 8*character.spring.x, 2, 2, color, 2
      for j = 1, character.max_hp
        graphics.rectangle 48 + (j-1)*8, 100 + (i-1)*20, 5*@hp_spring.x, 5*@hp_spring.x, 1, 1, color, 1
      if not character.dead
        for j = 1, character.hp
          graphics.rectangle 48 + (j-1)*8, 100 + (i-1)*20, 5*@hp_spring.x, 5*@hp_spring.x, 1, 1, color

  on_collision_enter: (other, contact) =>
    if other.__class == Wall
      intensity = math.remap math.abs(@position_vx), 0, 20, 0, 1
      @hit_spring\pull 0.25*intensity
      camera\shake 2*intensity, 0.25*intensity
      x, y = contact\getPositions!
      for i = 1, 4
        r = 0
        if math.sign(@position_vx) == -1 then r = random\float -math.pi/2.5, math.pi/2.5
        elseif math.sign(@position_vx) == 1 then r = random\float math.pi - math.pi/2.5, math.pi + math.pi/2.5
        HitParticle effects, x, @y, {v: random\float(50, 150)*intensity, :r, color: @color, duration: random\float(0.2, 0.4)*intensity}
      with HitCircle effects, x, @y, {color: fg1}
        \scale_down 0.2
        \change_color 0.25, @color
      hit1\play pitch: random\float(0.95, 1.05), volume: intensity*0.35

  hit: =>
    @hit_spring\pull 0.15
    @hit_flash = true
    @timer\after 0.15, (-> @hit_flash = false), 'hit_flash'
    camera\spring_shake 3, math.pi/2

  add_character: (character) =>
    table.insert @characters, character

  switch_character: (character_index) =>
    if @characters[character_index].dead
      error1\play pitch: random\float(0.95, 1.05), volume: 0.5
      return
    switch1\play pitch: random\float(0.95, 1.05), volume: 0.5
    wind1\play pitch: random\float(0.95, 1.05), volume: 0.5
    @character_index = character_index
    @hp_spring\pull 0.15, 200, 10
    RefreshEffect effects, @x, @y, {parent: @, w: 1.2*@shape.w, h: 3*@shape.h}
    with @characters[character_index]
      @hp = .hp
      @max_hp = .max_hp
      @color = .color
      @special_cd = .special_cd
      @special = .special

  add_ball: =>
    ball = {color: red, spring: Spring 1}
    ball.spring\pull 0.5
    table.insert @balls, ball

  spawn_ball: =>
    shoot1\play pitch: random\float(0.95, 1.05), volume: 0.5
    ball = table.remove @balls, 1
    SpawnBall effects, @x, @y - 8, {color: ball.color}
    for ball in *@balls do ball.spring\pull 0.25
    @timer\cancel 'ball_limit'
    @timer\cancel 'ball_limit_1'
    @timer\cancel 'ball_limit_2'
    @timer\cancel 'ball_limit_3'
    @burst_timer = nil
    @burst_shake = 0

  add_score: =>
    @score += 1
    @chained_score += 1
    @score_spring\pull 0.5
    @score_hit_flash = true
    @timer\after 0.15, (-> @score_hit_flash = false), 'score_hit_flash'
    BumpInfoText effects, @x, @y + 12, {color: fg1, text: '+' .. tostring(@chained_score), duration_multiplier: 0.5, size_multiplier: 0.9}

  miss: (x=@x) =>
    hit3\play pitch: random\float(0.95, 1.05), volume: 0.5
    @chained_score = 0
    @score_spring\pull 0.5
    BumpInfoText effects, x, gh, {color: red, text: 'miss..', vertical_multiplier: -1}
    slow 0.5, 0.5
    camera\shake 5, 0.5
    @\change_hp -1

  change_hp: (n=1) =>
    @hp += n
    @characters[@character_index].hp = @hp
    @hp_spring\pull 0.5
    @score_hit_flash = true
    @hp_hit_flash = true
    @timer\after 0.15, (-> @hp_hit_flash = false), 'hp_hit_flash'
    if @hp <= 0
      slow 0.25, 0.5
      @characters[@character_index].dead = true
      if not @characters[1].dead
        @\switch_character 1
        return
      if not @characters[2].dead
        @\switch_character 2
        return
      if not @characters[3].dead
        @\switch_character 3
        return
      if not @characters[4].dead
        @\switch_character 4
        return

      @dead = true
      with HitCircle effects, @x, @y, {color: fg1}
        \scale_down 0.5
        \change_color 0.3, @characters[@character_index].color
      for i = 1, 8
        HitParticle effects, @x, @y, {color: @characters[@character_index].color, v: random\float(100, 200), duration: random\float(0.2, 1)}
      timer\after 0.5, (-> Score effects, gw/2, gh/2, {score: @score})
      balls = @group\get_objects_by_class Ball
      for ball in *balls do ball\die!


class Tutorial extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @color = fg3\clone!
    @timer\after 15, (->
      @timer\tween 0.25, @color, {a: 0}, math.linear, (->
        @dead = true
      )
    )

  update: (dt) =>
    @\update_game_object dt

  draw: =>
    [[
    -- logo
    graphics.print 'JUGGLRX', fat_font, @x, @y, 0, 1, 1, fat_font\get_text_width'JUGGLRX'/2, fat_font.h/2, fg1
    graphics.circle @x + 56, @y - 6, 4, green
    graphics.circle @x + 16, @y - 22, 4, blue
    graphics.circle @x - 11, @y + 9, 4, red
    graphics.circle @x - 32, @y - 24, 4, yellow
    graphics.circle @x - 56, @y - 8, 4, orange
    ]]
    graphics.print 'm1 - launch ball', fat_font, @x, @y, 0, 0.75, 0.75, fat_font\get_text_width'm1 - launch ball'/2, fat_font.h/2, @color
    graphics.print 'm2 - use ability', fat_font, @x, @y + 26, 0, 0.75, 0.75, fat_font\get_text_width'm2 - use ability'/2, fat_font.h/2, @color
    graphics.print '1, 2, 3, 4 - switch paddle', fat_font, @x, @y + 50, 0, 0.5, 0.5, fat_font\get_text_width'1, 2, 3, 4 - switch paddle'/2, fat_font.h/2, @color
    graphics.print 's - toggle sfx', fat_font, @x, @y + 100, 0, 0.5, 0.5, fat_font\get_text_width's - toggle sfx'/2, fat_font.h/2, @color
    graphics.print 'm - toggle music', fat_font, @x, @y + 120, 0, 0.5, 0.5, fat_font\get_text_width'm - toggle music'/2, fat_font.h/2, @color


class StickyWalls extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @spring = Spring 1
    @w = 0
    @timer\tween 0.05, @, {w: 5}, math.linear, (-> @spring\pull 0.25)
    @timer\after 5, (->
      @timer\tween 0.05, @, {w: 0}, math.linear, (->
        @dead = true
        blue2\play pitch: random\float(0.95, 1.05), volume: 0.5
      )
    )

  update: (dt) =>
    @\update_game_object dt
    @spring\update dt

  draw: =>
    graphics.line ax1, gh + 40, ax1, -40, blue, @w*@spring.x
    graphics.line ax2, gh + 40, ax2, -40, blue, @w*@spring.x


class Clone extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @\set_as_rectangle @w, 8, 'dynamic', 'player'
    @\set_gravity_scale 0
    @\set_fixed_rotation true
    RefreshEffect effects, @x, @y, {parent: @, w: 1.2*@shape.w, h: 3*@shape.h}
    @hit_spring = Spring 1
    @timer\after 10, (-> @\die!)
    if @seeker
      @timer\every_immediate 0.5, (->
        runs = 0
        while not @ball and runs < 50
          balls = @group\get_objects_by_class Ball
          ball = random\table balls
          if ball and not ball.taken and not ball.dead
            ball.taken = true
            @ball = ball
          runs += 1
      )

  update: (dt) =>
    @\update_game_object dt
    @hit_spring\update dt

    if @seeker
      if @ball and @ball.dead then
        @ball = nil
        @\die!
      if @ball
        @\move_towards_object @ball, nil, 0.02
        vx, vy = @\get_velocity!
        @\set_velocity vx, 0

  draw: =>
    color = @color
    if @hit_flash then color = fg1
    graphics.push @x, @y, 0, @hit_spring.x, @hit_spring.x
    graphics.rectangle @x, @y, @shape.w, @shape.h, 4, 4, color
    graphics.pop!

    if @ball
      graphics.dashed_rounded_line @x - 1.5, @y - 12, @ball.x - 1.5, @ball.y + 12, 8, 8, color, 6

  hit: =>
    @hit_spring\pull 0.15
    @hit_flash = true
    @timer\after 0.15, (-> @hit_flash = false), 'hit_flash'
    camera\spring_shake 2, math.pi/2

  die: =>
    with HitCircle effects, @x, @y, {color: fg1}
      \scale_down 0.5
      \change_color 0.3, @color
    for i = 1, 8
      HitParticle effects, @x, @y, {color: @color, v: random\float(100, 200), duration: random\float(0.2, 1)}
    @dead = true
    if @seeker and @ball then @ball.taken = false


class StasisArea extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @shape = Rectangle @x, @y, gw/4, 1.2*gh
    @color = Color red.r, red.g, red.b, 0.25
    @spring = Spring 1
    @wm = 1
    @timer\every_immediate 1, (-> @spring\pull 0.05)
    @timer\every 0.15, (-> StasisParticle effects, random\float(@x - 0.4*@shape.w, @x + 0.4*@shape.w), random\float(@y - 0.4*@shape.h, @y + 0.4*@shape.h))
    @timer\after 5, (->
      player.red_beam\pause 0.5
      red4\play pitch: random\float(0.95, 1.05), volume: 0.5
      @timer\tween 0.5, @, {wm: 0}, math.cubic_in_out, (->
        @dead = true
        player.red_beam = nil
      )
    )

  update: (dt) =>
    @\update_game_object dt
    @spring\update dt

  draw: =>
    graphics.push @x, @y, 0, @spring.x, @spring.x
    graphics.rectangle @x, @y, @wm*@shape.w, @shape.h, nil, nil, @color
    if @wm >= 1
      graphics.rectangle @x, @y, @shape.w, @shape.h, nil, nil, red, 2
    graphics.pop!
    if @wm < 1
      graphics.line @x + @spring.x*@wm*@shape.w/2, @y + @shape.h/2, @x + @spring.x*@wm*@shape.w/2, @y - @shape.h/2, red, 2
      graphics.line @x - @spring.x*@wm*@shape.w/2, @y + @shape.h/2, @x - @spring.x*@wm*@shape.w/2, @y - @shape.h/2, red, 2


class StasisParticle extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @v = 0
    @h = 0
    @w = 4
    @timer\tween 0.03, @, {h: random\float(8, 16), v: random\float(0, 50)}, math.linear, (->
      @timer\after random\float(0.2, 0.6), (->
        @timer\tween random\float(0.1, 0.2), @, {w: 0, h: 0}, math.linear, (-> @dead = true)
      )
    )

  update: (dt) =>
    @\update_game_object dt
    @y -= @v*dt

  draw: =>
    graphics.rectangle @x, @y, @w, @h, 2, 2, red


class Ball extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @\set_as_circle 4.5, 'dynamic', 'enemy'
    @\set_fixed_rotation true
    @hit_spring = Spring 1
    @color = red
    if @vx and @vy
      @\set_velocity @vx, @vy
    else
      @\set_velocity 0, -230
    @bounces = 0
    @just_spawned = true
    @timer\after 0.05, (->
      @just_spawned = false
      @vy = false
    )
    @_vy = 0
    @ay = 0
    @in_stasis_area = false

  update: (dt) =>
    @\update_game_object dt
    @hit_spring\update dt
    vx, vy = @\get_velocity!
    @\set_velocity vx, math.clamp(vy, -500, 500) - @ay*dt

    stasis_areas = @group\get_objects_by_class StasisArea
    for sa in *stasis_areas
      if @\is_colliding_with_shape sa.shape then
        @\set_gravity_scale 0
        @\set_damping 2
        @in_stasis_area = true
      else
        @\set_gravity_scale 1
        @\set_damping 0
        @in_stasis_area = false
    if #stasis_areas <= 0 then @in_stasis_area = false

    if not @in_stasis_area and @previous_in_stasis_area
      @\set_gravity_scale 1
      @\set_damping 0
      @\apply_impulse random\float(-5, 5), -5
    @previous_in_stasis_area = @in_stasis_area

    if @y > gh + 40
      @\die!
      player\miss @x

  draw: =>
    color = @color
    if @hit_flash then color = fg1
    graphics.circle @x, @y, @shape.rs*@hit_spring.x, color

  on_collision_enter: (other, contact) =>
    if other.__class == Player or other.__class == Clone
      x, y = contact\getPositions!
      vx, vy = @\get_velocity!
      distance_from_center = math.abs(other.x - @x)
      direction_of_impulse = math.sign(@x - other.x)
      if not @vy and not @just_spawned
        vy = -230
        if @color == red then vy = -230
        if distance_from_center < other.shape.w/8 then @\set_velocity vx/2, vy
        elseif distance_from_center >= other.shape.w/8 then @\set_velocity 50*math.sign(@x - other.x)*math.remap(math.abs(other.x - @x), 0, other.shape.w/2, 0, 4), vy
        hit4\play pitch: random\float(0.9, 1.1), volume: 0.4
        pop1\play pitch: random\float(0.95, 1.05), volume: 0.3
      @\hit!
      other\hit!
      for i = 1, 4 do HitParticle effects, x, y, {v: random\float(100, 150), r: random\float(-3*math.pi/4, -math.pi/4), color: @color, duration: random\float(0.2, 0.4)}
      player\add_score!

    elseif other.__class == Wall
      x, y = contact\getPositions!
      vx, vy = @\get_velocity!
      if player.sticky_walls
        @stuck = true
        @\set_velocity 0, 0
        @\set_gravity_scale 0
        r = 0
        if @x > gw/2 then r = random\float math.pi - math.pi/2.5, math.pi + math.pi/2.5
        elseif @x < gw/2 then r = random\float -math.pi/2.5, math.pi/2.5
        for i = 1, 3
          HitParticle effects, x, y, {v: random\float(100, 200), :r, color: blue, duration: random\float(0.2, 0.4), w: random\float(5, 8)}
        random\table({stick1, stick2})\play pitch: random\float(0.95, 1.05), volume: 0.25

      else
        @\set_velocity -vx, vy
        @hit_spring\pull 0.15
        r = 0
        if @x > gw/2 then r = random\float math.pi - math.pi/2.5, math.pi + math.pi/2.5
        elseif @x < gw/2 then r = random\float -math.pi/2.5, math.pi/2.5
        for i = 1, 2
          HitParticle effects, x, y, {v: random\float(50, 150), :r, color: red, duration: random\float(0.2, 0.4)}
        hit1\play pitch: random\float(0.95, 1.05), volume: 0.05

  hit: (m=1) =>
    @hit_spring\pull m*0.25
    @hit_flash = true
    @timer\after 0.1, (-> @hit_flash = false), 'hit_flash'

  die: =>
    @dead = true
    with HitCircle effects, @x, @y, {color: fg1}
      \scale_down 0.2
      \change_color 0.25, @color
    for i = 1, 4 do HitParticle effects, @x, @y, {color: @color, v: random\float(100, 150)}


class BumpInfoText extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @text_object = Text('[wavy][color]' .. @text, {
      wavy: TextTag({
        update: ((c, dt, i, text) ->
          c.oy = 8*math.sin(2*time + i)
        )
      })
      color: TextTag({
        init: ((c, i, text) ->
          c.color = fg1
          @timer\after 0.15, (->
            c.color = @color
          )
        )
        draw: ((c, i, text) ->
          graphics.set_color c.color
        )
      })
    }, fat_font)

    @sx, @sy = 0.5*(@size_multiplier or 1), 0.5*(@size_multiplier or 1)
    @spring = Spring 1
    @spring\pull 0.5
    @timer\tween 1*(@duration_multiplier or 1), @, {y: @y + 20*(@vertical_multiplier or 1)}, math.expo_out, (->
      @timer\tween 0.05, @, {sx: 0, sy: 0}, math.linear, (-> @dead = true)
    )

  update: (dt) =>
    @\update_game_object dt
    @text_object\update dt
    @spring\update dt

  draw: =>
    graphics.push @x, @y, 0, @sx*@spring.x, @sy*@spring.x
    @text_object\draw @x - fat_font\get_text_width(@text_object.raw_text)/2, @y - fat_font\get_height!/2
    graphics.pop!


class Score extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    invisible = Color 1, 1, 1, 0
    @text = Text('[cbyc]score: ' .. @score, {
      cbyc: TextTag({
        init: ((c, i, text) ->
          c.color = invisible
          timer\after (i-1)*0.2, (->
            c.color = fg1
            camera\shake 3, 0.12
            hit1\play pitch: random\float(0.95, 1.05), volume: 0.35
          )
        )
        draw: ((c, i, text) ->
          graphics.set_color(c.color)
        )
      })
    }, fat_font)

    @restart = true
    @timer\tween 1, _G, {slow_amount: 0}, math.linear

  update: (dt) =>
    @\update_game_object dt
    @text\update

  draw: =>
    @text\draw @x - @text.font\get_text_width(@text.raw_text)/2, @y - @text.font.h/2
    if @restart
      graphics.print 'r - restart', fat_font, @x, @y + 32, 0, 0.75, 0.75, fat_font\get_text_width'r - restart'/2, fat_font.h/2, fg3


class SpawnBall extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @target_color = @color or red
    @color = fg1
    @rs = 6
    @spring = Spring 1
    @spring\pull 1
    for i = 1, random\int(6, 8) do HitParticle effects, @x, @y, {color: @target_color, duration: random\float(0.3, 0.5), w: random\float(5, 8), v: random\float(150, 200)}
    Ball main, @x, @y, {vx: @vx, vy: @vy}
    @timer\tween 0.25, @, {rs: 0}, math.linear, (-> @dead = true)
    @timer\after 0.15, (-> @color = @target_color)

  update: (dt) =>
    @\update_game_object dt
    @spring\update dt

  draw: =>
    graphics.circle @x, @y, @rs*@spring.x, @color


class RefreshEffect extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @oy = @h/3
    @timer\tween 0.15, @, {h: 0}, math.linear, (-> @dead = true)

  update: (dt) =>
    @\update_game_object dt
    if @parent and @parent.dead
      @parent = nil
      @dead = true
      return
    @x, @y = @parent.x, @parent.y
    @r = @parent.r

  draw: =>
    graphics.push @x, @y, @r
    graphics.set_color fg1
    love.graphics.rectangle 'fill', @x - @w/2, @y - @oy, @w, @h
    graphics.pop!


slow = (amount=0.5, duration=0.5, tween_method=math.cubic_in_out) ->
  export *
  slow_amount = amount
  timer\tween duration, _G, {slow_amount: 1}, tween_method, (-> slow_amount = 1), 'slow'


flash = (duration=0.05, color=fg1) ->
  export *
  flashing = true
  flash_color = color
  timer\after duration, (-> flashing = false), 'flash'


class HitCircle extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @rs or= 8
    @duration or= 0.05
    @color or= white
    @timer\after @duration, (-> @dead = true), 'die'

  update: (dt) =>
    @\update_game_object dt

  draw: =>
    graphics.circle @x, @y, @rs, @color

  scale_down: (@duration=0.2) =>
    @timer\cancel 'die'
    @timer\tween @duration, @, {rs: 0}, math.cubic_in_out, (-> @dead = true)

  change_color: (delay_multiplier=0.5, target_color) =>
    @timer\after delay_multiplier*@duration, (-> @color = target_color)


class HitParticle extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @v or= random\float 50, 150
    @r = opts.r or random\float 0, 2*math.pi
    @duration or= random\float 0.2, 0.6
    @w or= random\float 3.5, 7
    @h or= @w/2
    @color or= white
    @timer\tween @duration, @, {w: 2, h: 2, v: 0}, math.cubic_in_out, (-> @dead = true)

  update: (dt) =>
    @\update_game_object dt
    @x += @v*math.cos(@r)*dt
    @y += @v*math.sin(@r)*dt

  draw: =>
    graphics.push @x, @y, @r
    graphics.rectangle @x, @y, @w, @h, 2, 2, @color
    graphics.pop!


class AnimationEffect extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @animation = Animation @delay, @frames, 'once', {[0]: (-> @dead = true)}
    @color or= white

  update: (dt) =>
    @\update_game_object dt
    @animation\update dt
    if @linear_movement
      @x += @v*math.cos(@r)*dt
      @y += @v*math.sin(@r)*dt

  draw: =>
    @animation\draw @x + (@ox or 0), @y + (@oy or 0), @r + (@oa or 0), (@flip_sx or 1)*@sx, (@flip_sy or 1)*@sy, nil, nil, @color

  set_linear_movement: (@v, @r) =>
    @linear_movement = true
    duration = @animation.size*@delay
    @timer\after 2*duration/3, (-> @timer\tween duration/3, @, {v: 0}, math.cubic_in_out)


class Wall extends GameObject
  new: (group, x, y, opts) =>
    super group, x, y, opts
    @\set_as_chain true, @vertices, 'static', 'solid'
    @color or= black

  update: (dt) =>
    @\update_game_object dt

  draw: =>
    @shape\draw @color


love.run = ->
  engine_run {
    moonscript: true,
    game_name: 'JUGGLRX'
    game_width: 480
    game_height: 270
    window_width: 480*3
    window_height: 270*3
    line_style: 'rough'
    default_filter: 'nearest'
    :init
    :update
    :draw
  }
