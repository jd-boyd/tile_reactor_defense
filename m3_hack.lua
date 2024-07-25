-- title:  Match-3 Game
-- author: Your Name
-- desc:   Basic Match-3 tile game
-- site:    website link
-- license: BSD
-- version: 0.1
-- script:  lua

Enum = require("enum")

-- Constants
TILE_SIZE = 12
GRID_WIDTH = 8
GRID_HEIGHT = 8

-- Select mode is moving the select around.
-- swap mode is picking a direction to swap two tiles.
InputModes = Enum("Select", "Swap")
input_mode = InputModes.Select

-- Variables
grid = {height=GRID_HEIGHT, width=GRID_WIDTH}
selected = {x = grid.width/2, y = grid.height/2}
--ctrl_mode = 
matches = {}

-- Initialize the grid with random tiles
function grid.init()
 for y=1, grid.height do
  grid[y] = {}
  for x=1, grid.width do
   grid[y][x] = math.random(1, 3) -- Three types of tiles
  end
 end
end

-- Draw the grid
function grid.draw()
   for y=1, grid.height do
      for x=1, grid.width do
	 local tile = grid[y][x]
	 local orig_x = (x-1)*TILE_SIZE
	 local orig_y = (y-1)*TILE_SIZE     
	 rect(orig_x, orig_y, TILE_SIZE, TILE_SIZE, tile)
	 if selected.x == x and selected.y == y then
	    rectb(orig_x, orig_y, TILE_SIZE, TILE_SIZE, 15) -- Highlight selected tile
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

-- Handle input
function handle_input()
 if btnp(0) then -- Up
  select_tile(0, -1)
 elseif btnp(1) then -- Down
  select_tile(0, 1)
 elseif btnp(2) then -- Left
  select_tile(-1, 0)
 elseif btnp(3) then -- Right
  select_tile(1, 0)
 elseif btnp(4) then -- Select -- d
    if input_mode == InputModes.Select then
       input_mode = InputModes.Swap
    else
       input_mode = InputModes.Select
    end
   -- for _, match in ipairs(matches) do
   --  if match.x == selected.x and match.y == selected.y then
   --   selected = nil
   --   return
   --  end
   -- end
 end
end

-- Select tile
function select_tile(dx, dy)
   local new_selected = {x=selected.x + dx, y=selected.y + dy}

   if input_mode == InputModes.Select then
      selected = new_selected
   elseif input_mode == InputModes.Swap then
      if new_selected.x > 0 and new_selected.x <= grid.width and new_selected.y > 0 and new_selected.y <= grid.height then
	 if are_adjacent(selected, new_selected) then
	    swap(selected, new_selected)
	    matches = grid.find_matches()
	    if #matches > 0 then
	       remove_matches()
	    else
	       swap(selected, new_selected)
	    end
	 end
      end
   else
      -- error
   end
end

-- TIC function
function TIC()
 handle_input()
 cls(0)
 grid.draw()
end

function BOOT()
   -- Initialize the game
   grid.init()
   find_matches()
end

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

