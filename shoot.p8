pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--character
character8x8={}
character8x8.new = function(self, _x, _y)
  self.x = _x
  self.y = _y
  self.life = 1
end

--player
player={}
player.new = function()
  local p = {}

  p.bullets={}
  p.x = 64
  p.y = 100
  p.previous_key1=false

  p.shot = function(self)
    add(self.bullets, bullet.new(self.x, self.y))
  end

  p.update = function(self)
    if(btn(0) and self.x>0)   self.x-=2
    if(btn(1) and self.x<128) self.x+=2
    if(btn(2) and self.y>0)   self.y-=2
    if(btn(3) and self.y<128) self.y+=2
    if(btn(4) and previous_key1==false) self:shot()
    previous_key1=btn(4)
  end

  p.draw = function(self)
    spr(1, self.x-4, self.y-4)
  end
  return p
end

bullet_count=0

--bullet
bullet = {}
bullet.new = function(_x, _y)
  local b = {}
  b.x = _x
  b.y = _y
  b.life = 50

  b.update = function(self)
    self.y -= 3
    self.life -= 1
    if(self.life < 1) del(pl.bullets, self)
  end

  b.draw =function(self)
    spr(5, self.x-4, self.y-4)
  end

  return b
end

function draw_bullets()
  foreach(pl.bullets, function(b)
    spr(5, b.x-4, b.y-4)
    b:draw()
  end)
end

function update_bullets()
  bullet_count=0
  foreach(pl.bullets, function(b)
    b:update()
  end)
end

function _init()
  pl = player.new()
end

function _update()
  pl:update()
  update_bullets()
end

function _draw()
  cls()
  pl:draw()
  draw_bullets()
  print(bullet_count)
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
00000000000bb000000bb000aaaaaaaa0aaaaaa00888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbbb0000bbbb00aa0aa0aaaa0aa0aa8008800880088008000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0bb0b00b0bb0b00a0aa0a0aa0aa0aa8808808888088088000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0bb0b00b0bb0b00aaaaaa00aaaaaa08888888888888888000000000000000000000000000000000000000000000000000000000000000000000000
000000000bbbbbb00bbbbbb000aaaa0000aaaa000888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbbb0000bbbb000a0aa0a00a0aa0a00888888008888880000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0bb0b00b0bb0b0000aa00000a00a000808080880808080000000000000000000000000000000000000000000000000000000000000000000000000
00000000b000000b0b0000b000a00a00aa0000aa0808080880808080000000000000000000000000000000000000000000000000000000000000000000000000
