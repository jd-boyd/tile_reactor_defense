-- title:  Match-3 Game
-- author: Your Name
-- desc:   Basic Match-3 tile game
-- site:    website link
-- license: BSD
-- version: 0.1
-- script:  lua

-- Constants
TILE_SIZE = 16
GRID_WIDTH = 8
GRID_HEIGHT = 8

-- Variables
grid = {}
selected = nil
matches = {}

-- Initialize the grid with random tiles
function init_grid()
 for y=1, GRID_HEIGHT do
  grid[y] = {}
  for x=1, GRID_WIDTH do
   grid[y][x] = math.random(1, 3) -- Three types of tiles
  end
 end
end

-- Draw the grid
function draw_grid()
 for y=1, GRID_HEIGHT do
  for x=1, GRID_WIDTH do
   local tile = grid[y][x]
   rect((x-1)*TILE_SIZE, (y-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE, tile)
   if selected and selected.x == x and selected.y == y then
    rectb((x-1)*TILE_SIZE, (y-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE, 15) -- Highlight selected tile
   end
  end
 end
end

-- Check for matches
function find_matches()
 matches = {}
 for y=1, GRID_HEIGHT do
  for x=1, GRID_WIDTH do
   local tile = grid[y][x]
   if x <= GRID_WIDTH - 2 and grid[y][x+1] == tile and grid[y][x+2] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x+1, y=y})
    table.insert(matches, {x=x+2, y=y})
   end
   if y <= GRID_HEIGHT - 2 and grid[y+1][x] == tile and grid[y+2][x] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x, y=y+1})
    table.insert(matches, {x=x, y=y+2})
   end
  end
 end
end

-- Remove matches and fill the grid
function remove_matches()
 for _, match in ipairs(matches) do
  grid[match.y][match.x] = 0
 end
 for x=1, GRID_WIDTH do
  for y=GRID_HEIGHT, 2, -1 do
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
 elseif btnp(4) then -- Select
  if selected then
   for _, match in ipairs(matches) do
    if match.x == selected.x and match.y == selected.y then
     selected = nil
     return
    end
   end
   selected = nil
  else
   selected = {x=math.floor((mouse_x() // TILE_SIZE) + 1), y=math.floor((mouse_y() // TILE_SIZE) + 1)}
  end
 end
end

-- Select tile
function select_tile(dx, dy)
 if selected then
  local new_selected = {x=selected.x + dx, y=selected.y + dy}
  if new_selected.x > 0 and new_selected.x <= GRID_WIDTH and new_selected.y > 0 and new_selected.y <= GRID_HEIGHT then
   if are_adjacent(selected, new_selected) then
    swap(selected, new_selected)
    find_matches()
    if #matches > 0 then
     remove_matches()
    else
     swap(selected, new_selected)
    end
   end
   selected = nil
  end
 else
  selected = {x=math.floor((mouse_x() // TILE_SIZE) + 1), y=math.floor((mouse_y() // TILE_SIZE) + 1)}
 end
end

-- TIC function
function TIC()
 handle_input()
 cls(0)
 draw_grid()
end

-- Initialize the game
init_grid()
find_matches()

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

