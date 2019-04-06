pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--global vars
shot_count=0
shots={}
enemys={}
interval=5
count_combinations=0

--character
__character={}
__character.new = function(self, _x, _y)
  local obj = {}

  obj.x = _x
  obj.y = _y
  obj.life = 1
  obj.sprite = 0

  function obj:draw()
    spr(obj.sprite, obj.x - 4, obj.y - 4)
  end

  return obj
end

--player
player={}
player.new = function()
  local this = __character:new(_x, _y)

  this.x = 64
  this.y = 100
  this.previous_key1=false
  this.sprite = 1

  this.fire = function(self)
    add(shots, shot.new(self.x, self.y))
    add(shots, shot.new(self.x-3, self.y))
    add(shots, shot.new(self.x+3, self.y))
    sfx(0)
  end

  this.update = function(self)
    if(btn(0) and self.x>0)   self.x-=2
    if(btn(1) and self.x<128) self.x+=2
    if(btn(2) and self.y>0)   self.y-=2
    if(btn(3) and self.y<128) self.y+=2
    if(btn(4) and previous_key1==false) self:fire()
    if(btn(5)) then
      interval -= 1
      if(interval < 1) interval=5
    end
    previous_key1=btn(4)
  end

  this.draw = function(self)
    spr(1, self.x-4, self.y-4)
  end

  return this 
end


enemy = {}
enemy.new = function(_x, _y)
  local this = __character:new(_x, _y)
  this.speed = flr(rnd(3)) + 1
  this.sprite = 17
  
  this.update = function(self)
    self.y += self.speed
    if(self.y > 128) then
      del(enemys, self)
    end
  end

  return this 
end


--shot
shot = {}
shot.new = function(_x, _y)
  local this = __character:new(_x, _y)
  this.life = 50
  this.sprite = 5

  this.update = function(self)
    self.y -= 3
    self.life -= 1
    if(self.life < 1) del(shots, self)
  end

  return this
end

function draw_shots()
  foreach(shots, function(b)
    spr(5, b.x-4, b.y-4)
    b:draw()
  end)
end

function update_shots()
  shot_count=0
  foreach(shots, function(b)
    b:update()
  end)
end

function draw_enemys()
  foreach(enemys, function(e)
    e:draw()
  end)
end

function update_enemys()
  foreach(enemys, function(e)
    e:update()
  end)
end

function generate_enemys()
  if(flr(rnd(interval))==0) then
    add(enemys, enemy.new(rnd(128), 0))
    add(enemys, enemy.new(rnd(128), 0))
  end
end

function collide_shot_enemy()
  count_combinations = 0
  foreach(shots, function(s)
    foreach(enemys, function(e)
      if(collide(s, e)) then
        del(shots, s)
        del(enemys, e)
        sfx(1)
      end
      count_combinations += 1
    end)
  end)
end

function collide(obj1, obj2)
  return sqrt((obj1.x-obj2.x)^2 + (obj1.y-obj2.y)^2) < 4
end


function _init()
  pl = player.new()
end

function _update()
  pl:update()
  generate_enemys()
  update_enemys()
  update_shots()
  collide_shot_enemy()
end

function _draw()
  cls()
  pl:draw()
  draw_enemys()
  draw_shots()
  print("shots :" ..#shots)
  print("enemys:" ..#enemys)
  print("intrvl:" ..interval)
  print("combi :" ..count_combinations)
end

__gfx__
00000000000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000660000000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006656000000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006665000000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066656500000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700066665600000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666556560000000000000000000000000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000665555650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000002200000022000aaaaaaaa0aaaaaa00888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
000000000022220000222200aa0aa0aaaa0aa0aa8008800880088008000000000000000000000000000000000000000000000000000000000000000000000000
0000000002022020020220200a0aa0a0aa0aa0aa8808808888088088000000000000000000000000000000000000000000000000000000000000000000000000
0000000002022020020220200aaaaaa00aaaaaa08888888888888888000000000000000000000000000000000000000000000000000000000000000000000000
00000000022222200222222000aaaa0000aaaa000888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
0000000000222200002222000a0aa0a00a0aa0a00888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
000000000202202002022020000aa00000a00a000808080880808080000000000000000000000000000000000000000000000000000000000000000000000000
00000000200000020200002000a00a00aa0000aa0808080880808080000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002c0503005034050350503705037050370503705034050320502f0502a0502705023050200501c05019050160501405012050100500e0500d0500c0500b0500a050090500905009050080500905009050
00010000175501b5501f5502355026550285502b5502e550315503355035550365503855039550395503955039550395503855037550365503455031550305502e5502a550285502455022550205501c5501a550
