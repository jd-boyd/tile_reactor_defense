
Grid = require('./grid')
Enum = require("./enum")

-- Constants
TILE_SIZE = 16
GRID_WIDTH = 7
GRID_HEIGHT = 8

-- Select mode is moving the select around.
-- swap mode is picking a direction to swap two tiles.
InputModes = Enum("Select", "Swap")

M3_Game = {}

function M3_Game:new ()
   o = {
      grid = Grid:new(GRID_WIDTH, GRID_HEIGHT), 
      selected = {x = math.ceil(grid.width/2), y = grid.height/2},
      --ctrl_mode = 
      matches = {},
      input_mode = InputModes.Select,
   }   
   setmetatable(o, self)
   self.__index = self
   return o
end

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
trace("TS:")
tprint(tile_sprs, 2)

-- Draw the grid
function M3_Game:grid_draw()
   -- trace("gd")
   -- tprint(self.grid, 1)
   self.grid:test()
   for y=1, self.grid.height do
      for x=1, self.grid.width do
	 local tile = self.grid[y][x]
	 local orig_x = (x-1)*TILE_SIZE
	 local orig_y = (y-1)*TILE_SIZE
	 --trace(y .. ' ' ..  x .. ' ' .. tile)
	 local tile_grp = tile_sprs[tile]
	 --trace(tile .. " " .. tile_grp)
	 spr(tile_grp, orig_x+120, orig_y, 1, 1, 0, 0,2,2)
	 
	 if self.selected.x == x and self.selected.y == y then
	    local color = 13
	    trace("selected: " .. x .. " " .. y .. " " .. self.grid[y][x] .. " " .. tile_sprs[self.grid[y][x]])
	    if self.input_mode == InputModes.Swap then
	       color = 4
	    end
	    rectb(orig_x+120, orig_y, TILE_SIZE, TILE_SIZE, color) 

	 end
      end
   end
end

-- Select tile
function M3_Game:select_tile(dx, dy)
   local new_selected = self.grid:pt(self.selected.x + dx, self.selected.y + dy)

   -- trace("selected:")
   -- tprint(self.selected, 1)
   
   -- trace("new_sel:")
   -- tprint(new_selected, 1)
   
   if self.input_mode == InputModes.Select then
      self.selected = new_selected
   elseif self.input_mode == InputModes.Swap then
      self.input_mode = InputModes.Select
      if new_selected.x > 0 and new_selected.x <= self.grid.width and new_selected.y > 0 and new_selected.y <= self.grid.height then
	 if self.grid:are_adjacent(selected, new_selected) then
	    self.grid:swap(selected, new_selected)
	    matches = self.grid:find_matches()
	    if #matches > 0 then
	       self.grid:remove_matches(matches)
	       self.events:emit('bullet', 0)
	    else
	       self.grid:swap(selected, new_selected)
	    end
	 end
      end
      selected=new_selected
   else
      -- error
   end
end

function M3_Game:move_up ()
   self:select_tile(0, -1)
end

function M3_Game:move_down ()
   self:select_tile(0, 1)
end

function M3_Game:move_left ()
  self:select_tile(-1, 0)
end      

function M3_Game:move_right ()
   self:select_tile(1, 0)
end

function M3_Game:draw ()
   self:grid_draw()
end

function M3_Game:init (events)
   self.events = events
   self.grid:init(6)
   self.grid:test()
   local clean = self.grid:find_matches()
   if #clean then
      self.grid:remove_matches(clean)
   end
   self.grid:test()   
end

return M3_Game
