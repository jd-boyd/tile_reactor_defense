-- Missile Command for TIC-80
-- Press 'Z' to shoot

-- Constants
SCREEN_WIDTH = 240
SCREEN_HEIGHT = 136
MISSILE_SPEED = 1
BULLET_SPEED = 2

-- Variables
missiles = {}
bullets = {}
explosions = {}
score = 0
game_over = false

function init()
    for i = 1, 5 do
        add_missile()
    end
end

function add_missile()
    local missile = {
        x = math.random(0, SCREEN_WIDTH),
        y = 0,
        target_x = math.random(0, SCREEN_WIDTH),
        target_y = SCREEN_HEIGHT,
        speed = MISSILE_SPEED
    }
    table.insert(missiles, missile)
end

function add_bullet(x, y)
    local bullet = {
        x = x,
        y = y,
        speed = BULLET_SPEED
    }
    table.insert(bullets, bullet)
end

function update()
    if game_over then return end

    -- Update missiles
    for i, missile in ipairs(missiles) do
        missile.y = missile.y + missile.speed
        if missile.y >= missile.target_y then
            game_over = true
        end
    end

    -- Update bullets
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - bullet.speed
    end

    -- Check collisions
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        for j = #missiles, 1, -1 do
            local missile = missiles[j]
            if math.abs(bullet.x - missile.x) < 2 and math.abs(bullet.y - missile.y) < 2 then
                table.remove(bullets, i)
                table.remove(missiles, j)
                score = score + 1
                add_missile()
                break
            end
        end
    end

    -- Remove off-screen bullets
    for i = #bullets, 1, -1 do
        if bullets[i].y < 0 then
            table.remove(bullets, i)
        end
    end
end

function TIC()
    if btnp(4) then -- 'Z' key to shoot
        add_bullet(SCREEN_WIDTH // 2, SCREEN_HEIGHT - 10)
    end

    update()
    draw()
end

function draw()
    cls(0)
    if game_over then
        print("Game Over", SCREEN_WIDTH // 2 - 30, SCREEN_HEIGHT // 2 - 6, 12)
        print("Score: " .. score, SCREEN_WIDTH // 2 - 30, SCREEN_HEIGHT // 2 + 6, 12)
    else
        for i, missile in ipairs(missiles) do
            rect(missile.x, missile.y, 2, 4, 8)
        end

        for i, bullet in ipairs(bullets) do
            rect(bullet.x, bullet.y, 1, 3, 12)
        end

        print("Score: " .. score, 5, 5, 12)
    end
end

init()

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

