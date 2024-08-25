
Events = require("events")
MC_Game = require("mc_lib")
M3_Game = require("m3_lib")
mc = {}
m3 = {}
events = Events:new()

function TIC()
    -- if btnp(4) then -- 'Z' key to shoot
    --     MC_Game:add_bullet(SCREEN_WIDTH // 2, SCREEN_HEIGHT - 10)
    -- end
    handle_input()

    mc:update()

    cls(0)
    mc:draw()    
    m3:draw()
end

function BOOT()
   mc = MC_Game:new()
   m3 = M3_Game:new()
   mc:init(events)
   m3:init(events)   
end

-- Handle input
function handle_input()
 if btnp(0) then -- Up
    m3:move_up()
 elseif btnp(1) then -- Down
    m3:move_down()
 elseif btnp(2) then -- Left
    m3:move_left()
 elseif btnp(3) then -- Right
    m3:move_right()    
 elseif btnp(4) then -- Select -- d
    if m3.input_mode == InputModes.Select then
       m3.input_mode = InputModes.Swap
    else
       m3.input_mode = InputModes.Select
    end
 end
end


