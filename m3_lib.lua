package.path=package.path..";/var/home/jdboyd/work/bubble_reactor_defense/gri.lua"

Grid = require('./grid')
Enum = require("./enum")

-- Constants
TILE_SIZE = 16
GRID_WIDTH = 7
GRID_HEIGHT = 8

-- Select mode is moving the select around.
-- swap mode is picking a direction to swap two tiles.
InputModes = Enum("Select", "Swap")
input_mode = InputModes.Select

-- Variables
grid = Grid:new(GRID_WIDTH, GRID_HEIGHT) --{height=GRID_HEIGHT, width=GRID_WIDTH}
selected = {x = math.ceil(grid.width/2), y = grid.height/2}
--ctrl_mode = 
matches = {}

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      trace(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      trace(formatting .. tostring(v))      
    elseif type(v) == 'function' then
      trace(formatting .. "func")      
    else
      trace(formatting .. v)
    end
  end
end

tile_sprs = {
   160,
   162,
   192,
   194,
   224,
   226,
}

--trace(tile_sprs)
tprint(tile_sprs, 2)

-- Draw the grid
function grid.draw()
   trace("gd")
   tprint(grid, 1)
   for y=1, grid.height do
      for x=1, grid.width do
	 local tile = grid[y][x]
	 local orig_x = (x-1)*TILE_SIZE
	 local orig_y = (y-1)*TILE_SIZE
	 trace(y .. ' ' ..  x .. ' ' .. tile)
	 tile_grp = tile_sprs[tile]
	 trace(tile .. " " .. tile_grp)
	 spr(tile_grp, orig_x+120, orig_y, 1, 1, 0, 0,2,2)
	 
	 if selected.x == x and selected.y == y then
	    color = 13
	    if input_mode == InputModes.Swap then
	       color = 4
	    end
	    rectb(orig_x+120, orig_y, TILE_SIZE, TILE_SIZE, color) 

	 end
      end
   end
end

-- Select tile
function select_tile(dx, dy)
   local new_selected = Grid:pt(selected.x + dx, selected.y + dy)

   trace("selected:")
   tprint(selected, 1)
   
   trace("new_sel:")
   tprint(new_selected, 1)

   
   if input_mode == InputModes.Select then
      selected = new_selected
   elseif input_mode == InputModes.Swap then
      input_mode = InputModes.Select
      if new_selected.x > 0 and new_selected.x <= grid.width and new_selected.y > 0 and new_selected.y <= grid.height then
	 if Grid:are_adjacent(selected, new_selected) then
	    grid:swap(selected, new_selected)
	    matches = grid:find_matches()
	    if #matches > 0 then
	       grid:remove_matches(matches)
	    else
	       grid:swap(selected, new_selected)
	    end
	 end
      end
      selected=new_selected
   else
      -- error
   end
end

M3_Game = {
}

function M3_Game:move_up ()
   select_tile(0, -1)
end

function M3_Game:move_down ()
   select_tile(0, 1)
end

function M3_Game:move_left ()
  select_tile(-1, 0)
end      

function M3_Game:move_right ()
   select_tile(1, 0)
end

function M3_Game:draw ()
   grid.draw()
end

function M3_Game:init ()
   grid:init(6)
   grid:find_matches()
end

return M3_Game
