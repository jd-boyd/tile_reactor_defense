-- Constants
SCREEN_WIDTH = 110
SCREEN_HEIGHT = 126
MISSILE_SPEED = 0.125
BULLET_SPEED = 2

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
missiles = Queue:new()
missiles.last_add = 0
function missiles.add ()
    local missile = Missile:new({
        x = math.random(0, SCREEN_WIDTH),
        y = 8,
        target_x = math.random(0, SCREEN_WIDTH),
        target_y = SCREEN_HEIGHT,
        speed = MISSILE_SPEED
    })
    missiles:pushtail(missile)
    missiles.last_add = time()
end
function missiles.draw()
   for i, missile in ipairs(missiles) do
      --rect(missile.x, missile.y, 2, 4, 8)
      spr(19, missile.x, missile.y, 1, 1, 0, 0,1,1)
   end
end

function missiles.update()
    for i, missile in ipairs(missiles) do
       missile:update() 
        if missile.y >= missile.target_y then
            --game_over = true
        end
    end
end


MC_Game = {
   bullets = {},
   explosions = {},
   score = 0,
   game_over = false,
}
function MC_Game:init()
    for i = 1, 3 do
        missiles.add()
    end
    for i, v in ipairs(missiles) do
       trace(i,v)
    end
end

function MC_Game:add_bullet(x, y)
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
    missiles.update()

    if time() - missiles.last_add > 5000 then
       missiles.add()
    end
    
    -- Update bullets
    for i, bullet in ipairs(self.bullets) do
        bullet.y = bullet.y - bullet.speed
    end

    -- Check collisions
    for i = #self.bullets, 1, -1 do
        local bullet = self.bullets[i]
        for j = #missiles, 1, -1 do
            local missile = missiles[j]
            if math.abs(bullet.x - missile.x) < 2 and math.abs(bullet.y - missile.y) < 2 then
                table.remove(bullets, i)
                table.remove(missiles, j)
                self.score = self.score + 1
                add_missile()
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
   cls(0)
   map(0, 0, 30, 20, 0, 0, -1, 1, nil)
    if game_over then
        print("Game Over", SCREEN_WIDTH // 2 - 30, SCREEN_HEIGHT // 2 - 6, 12)
        print("Score: " .. score, SCREEN_WIDTH // 2 - 30, SCREEN_HEIGHT // 2 + 6, 12)
    else
       missiles.draw()
       
        for i, bullet in ipairs(self.bullets) do
            rect(bullet.x, bullet.y, 1, 3, 12)
        end

        --print("Score: " .. score, 5, 5, 12)
    end
end

return MC_Game
