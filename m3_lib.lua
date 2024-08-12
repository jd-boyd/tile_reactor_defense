Enum = require("enum")
Grid = require('grid')
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

-- Initialize the grid with random tiles
function grid.init()
 for y=1, grid.height do
  grid[y] = {}
  for x=1, grid.width do
   grid[y][x] = math.random(1, 6) -- Six types of tiles
  end
 end
end

tile_sprs = {
   {160, 161, 176, 177},
   {162, 163, 178, 179},
   {192, 193, 208, 209},
   {194, 195, 210, 211},
   {224, 225, 240, 241},
   {226, 227, 242, 243},     
}

trace(tile_sprs)

-- Draw the grid
function grid.draw()
   for y=1, grid.height do
      for x=1, grid.width do
	 local tile = grid[y][x]
	 local orig_x = (x-1)*TILE_SIZE
	 local orig_y = (y-1)*TILE_SIZE

	 tile_grp = tile_sprs[tile]
	 spr(tile_grp[1], orig_x+120, orig_y, 1, 1, 0, 0,2,2)
	 
	 if selected.x == x and selected.y == y then
	    color = 13
	    if input_mode == InputModes.Swap then
	       color = 4
	    end
	    rectb(orig_x+120, orig_y, TILE_SIZE, TILE_SIZE, color) -- Highlight selected tile

	 end
      end
   end
end

-- Select tile
function select_tile(dx, dy)
   local new_selected = {x=selected.x + dx, y=selected.y + dy}

   if input_mode == InputModes.Select then
      selected = new_selected
   elseif input_mode == InputModes.Swap then
      input_mode = InputModes.Select
      if new_selected.x > 0 and new_selected.x <= grid.width and new_selected.y > 0 and new_selected.y <= grid.height then
	 if are_adjacent(selected, new_selected) then
	    grid:swap(selected, new_selected)
	    matches = grid:find_matches()
	    if #matches > 0 then
	       --remove_matches()
	    else
	       grid:swap(selected, new_selected)
	    end
	 end
      end
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
   grid.init()
   grid:find_matches()
end

return M3_Game
