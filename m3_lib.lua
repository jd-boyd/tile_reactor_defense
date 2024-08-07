Enum = require("enum")

-- Constants
TILE_SIZE = 16
GRID_WIDTH = 7
GRID_HEIGHT = 8

-- Select mode is moving the select around.
-- swap mode is picking a direction to swap two tiles.
InputModes = Enum("Select", "Swap")
input_mode = InputModes.Select

-- Variables
grid = {height=GRID_HEIGHT, width=GRID_WIDTH}
selected = {x = math.ceil(grid.width/2), y = grid.height/2}
--ctrl_mode = 
matches = {}

-- Initialize the grid with random tiles
function grid.init()
 for y=1, grid.height do
  grid[y] = {}
  for x=1, grid.width do
   grid[y][x] = math.random(1, 4) -- Three types of tiles
  end
 end
end

tile_sprs = {
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
	 trace(tile)
	 tile_grp = tile_sprs[tile]
	 spr(tile_grp[1], orig_x+120, orig_y, 1, 1, 0, 0,1,1)
	 spr(tile_grp[2], orig_x+128, orig_y, 1, 1, 0, 0,1,1)
	 spr(tile_grp[3], orig_x+120, orig_y+8, 1, 1, 0, 0,1,1)
	 spr(tile_grp[4], orig_x+128, orig_y+8, 1, 1, 0, 0,1,1)	 
	 
	 -- rect(orig_x+120, orig_y, TILE_SIZE, TILE_SIZE, tile)
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

-- Check for matches
function grid.find_matches()
 local matches = {}
 for y=1, grid.height do
  for x=1, grid.width do
   local tile = grid[y][x]
   if x <= grid.width - 2 and grid[y][x+1] == tile and grid[y][x+2] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x+1, y=y})
    table.insert(matches, {x=x+2, y=y})
   end
   if y <= grid.height - 2 and grid[y+1][x] == tile and grid[y+2][x] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x, y=y+1})
    table.insert(matches, {x=x, y=y+2})
   end
  end
 end
 return matches
end

-- Remove matches and fill the grid
function remove_matches()
 for _, match in ipairs(matches) do
  grid[match.y][match.x] = 0
 end
 for x=1, grid.width do
  for y=grid.height, 2, -1 do
   if grid[y][x] == 0 then
    grid[y][x] = grid[y-1][x]
    grid[y-1][x] = 0
   end
  end
  if grid[1][x] == 0 then
   grid[1][x] = math.random(1, 3)
  end
 end
end

-- Swap tiles
function swap(a, b)
 local temp = grid[a.y][a.x]
 grid[a.y][a.x] = grid[b.y][b.x]
 grid[b.y][b.x] = temp
end

-- Check if two tiles are adjacent
function are_adjacent(a, b)
 return math.abs(a.x - b.x) + math.abs(a.y - b.y) == 1
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
	    swap(selected, new_selected)
	    matches = grid.find_matches()
	    if #matches > 0 then
	       --remove_matches()
	    else
	       swap(selected, new_selected)
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
   grid.find_matches()
end

return M3_Game
