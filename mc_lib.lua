-- Constants
PLAY_WIDTH = 110
PLAY_HEIGHT = 126
MISSILE_SPEED = 0.125
BULLET_SPEED = 0.1

-- Classes

Missile = {
   x = 0,
   y = 0,
   target_x = 0,
   target_y = 0,
   speed = 0
}

function Missile:new (o)
   o = o or {   x = 0,
   y = 0,
   target_x = 0,
   target_y = 0,
   speed = 0
}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Missile:update()
   self.y = self.y + self.speed
end

-- Variables

MC_Game = {}

function MC_Game:new ()
   o =  {
      missiles = {}, 
      bullets = {},
      explosions = {},
      score = 0,
      game_over = false,
      last_add = 0,
   }
   setmetatable(o, self)
   self.__index = self
   return o
end

function MC_Game:missiles_add ()
    local missile = Missile:new({
        x = math.random(0, PLAY_WIDTH),
        y = 0,
        target_x = math.random(0, PLAY_WIDTH),
        target_y = PLAY_HEIGHT,
        speed = MISSILE_SPEED
    })
    table.insert(self.missiles, missile)
    trace("Current missiles: ")
    for i, missile in ipairs(self.missiles) do
       trace(i .. " " .. missile.x .. " " .. missile.y)
    end
    self.last_add = time()
end

function MC_Game:missiles_draw()
   for i, missile in ipairs(self.missiles) do
      spr(19, missile.x, missile.y, 0, 1, 0, 0,1,1)
      print(missile.x .. "," .. math.floor(missile.y),
	    missile.x+10, missile.y, 12)      
   end
end

function MC_Game:missiles_update()
    for i, missile in ipairs(self.missiles) do
       missile:update() 
       if missile.y >= missile.target_y then
	  table.remove(self.missiles, i)
       end
    end
end

function MC_Game:init(events)
   trace("MC_Game:init")
   self.events = events
   self.events:on('bullet', function()
		     local m = self.missiles[1]
		     trace("NextM: " .. m.x .. " " .. m.y)
		     self:add_bullet(m.x+4, PLAY_HEIGHT - 10)
		     end
		     )
    for i = 1, 3 do
       self:missiles_add()
    end
end

function MC_Game:add_bullet(x, y)
   trace("Add bullet")
    local bullet = {
        x = x,
        y = y,
        speed = BULLET_SPEED
    }
    table.insert(self.bullets, bullet)
end

function MC_Game:update()
    if self.game_over then return end

    -- Update missiles
    self:missiles_update()

    if time() - self.last_add > 5000 then
       self:missiles_add()
    end
    
    -- Update bullets
    for i, bullet in ipairs(self.bullets) do
        bullet.y = bullet.y - bullet.speed
    end

    -- Check collisions
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        for j, missile in ipairs(self.missiles) do 
            if math.abs(bullet.x - missile.x) < 7 and math.abs(bullet.y - missile.y) < 5 then
	       trace("BH!")
	       table.remove(self.bullets, i)
	       table.remove(self.missiles, j)
                self.score = self.score + 1
                break
            end
        end
    end

    -- Remove off-screen bullets
    for i = #self.bullets, 1, -1 do
        if self.bullets[i].y < 0 then
            table.remove(self.bullets, i)
        end
    end
end

function MC_Game:draw()
   map(0, 0, 30, 30, 0, 0, -1, 1, nil)
   if game_over then
      local text_x = PLAY_WIDTH // 2 - 30
      print("Game Over", text_x, PLAY_HEIGHT // 2 - 6, 12)
      print("Score: " .. MC_Game.score, text_x, PLAY_HEIGHT // 2 + 6, 12)
   else
      self:missiles_draw()
      
      for i, bullet in ipairs(self.bullets) do
	 rect(bullet.x, bullet.y, 1, bullet.y, 12)
	 print(bullet.x .. "," .. math.floor(bullet.y), bullet.x+5, bullet.y, 12)      
      end
      print("Score: " .. self.score, 125, 130, 12)
   end
end

return MC_Game
