Grid = require('grid')
Enum = require("enum")
Pt = require("pt")

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
      selected = Pt:new{x = math.ceil(grid.width/2), y = grid.height/2},
      input_mode = InputModes.Select,
      particles = {},
   }
   setmetatable(o, self)
   self.__index = self
   return o
end

-- Variables
grid = Grid:new(GRID_WIDTH, GRID_HEIGHT) --{height=GRID_HEIGHT, width=GRID_WIDTH}

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

local part_sprs = {5, 7, 9, 11}

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

function new_part(p)
   return {
      x=p.x,
      y=p.y,
      life=12
   }
end

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
	    --trace("selected: " .. x .. " " .. y .. " " .. self.grid[y][x] .. " " .. tile_sprs[self.grid[y][x]])
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
   local new_x = self.selected.x + dx
   if new_x < 1 then
      new_x = 1
      return
   end
   if new_x > self.grid.width then
      new_x = self.grid.width
      return
   end

   local new_y = self.selected.y + dy
   if new_y < 1 then
      new_y = 1
      return
   end
   if new_y > self.grid.height then
      new_y = self.grid.height
      return
   end

   local new_selected = Pt:new(new_x, new_y)

   trace('sels: ' .. tostring(self.selected) .. ' ' .. tostring(new_selected) )

   if self.input_mode == InputModes.Select then
      self.selected = new_selected
   elseif self.input_mode == InputModes.Swap then
      self.input_mode = InputModes.Select

      local ret = self.grid:allow_swap(self.selected, new_selected)
      local allowed = ret[1]
      local matches = ret[2]
      trace('allow?: ' .. tostring(allowed) .. ' ' .. tostring(matches))
      if allowed then
	 self.grid:swap(self.selected, new_selected)
	 for i, m in pairs(matches) do
	    table.insert(self.particles, new_part(m))
	 end
	 self.grid:remove_matches(matches)
	 self.events:emit('bullet', 0)
      end
      self.selected=new_selected
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

function mod(a, b)
   return a - math.floor(a/b)*b
end

function M3_Game:draw ()
   self:grid_draw()
   if #self.particles > 0 then
      trace('drawing m3 particles: ' .. #self.particles)
      for i, m in pairs(self.particles) do
	 local orig_x = (m.x-1)*TILE_SIZE
	 local orig_y = (m.y-1)*TILE_SIZE
	 local part_num =  mod(m.life, #part_sprs)
	 local tile_grp = part_sprs[m.life]
	 --trace(tile .. " " .. tile_grp)
	 spr(tile_grp, orig_x+120, orig_y, -1, 1, 0, 0,2,2)
	 m.life = m.life -1
	 if m.life == 0 then
	    table.remove(self.particles, i)
	 end
      end
   end
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
