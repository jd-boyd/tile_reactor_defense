Grid = {height=GRID_HEIGHT, width=GRID_WIDTH}

function Grid:new (w, h)
   o = {   height = h,
	   width = w
   }   
   setmetatable(o, self)
   self.__index = self

 for y=1, h do
  o[y] = {}
  for x=1, w do
   o[y][x] = 0
  end
 end

   
   return o
end


function Grid:init(h, w)
 for y=1, self.height do
--  self[y] = {}
  for x=1, self.width do
   self[y][x] = math.random(1, 6) -- Six types of tiles
  end
 end
end

function Grid:find_matches()
 local matches = {}
 for y=1, self.height do
  for x=1, self.width do
   local tile = self[y][x]
   if x <= self.width - 2 and self[y][x+1] == tile and self[y][x+2] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x+1, y=y})
    table.insert(matches, {x=x+2, y=y})
   end
   if y <= self.height - 2 and self[y+1][x] == tile and self[y+2][x] == tile then
    table.insert(matches, {x=x, y=y})
    table.insert(matches, {x=x, y=y+1})
    table.insert(matches, {x=x, y=y+2})
   end
  end
 end
 return matches
end

-- Remove matches and fill the grid
function Grid:remove_matches(matches)
 for _, match in ipairs(matches) do
  self[match.y][match.x] = 0
 end
 for x=1, self.width do
  for y=self.height, 2, -1 do
   if self[y][x] == 0 then
    self[y][x] = self[y-1][x]
    self[y-1][x] = 0
   end
  end
  if self[1][x] == 0 then
   self[1][x] = math.random(1, 3)
  end
 end
end

-- Swap tiles
function Grid:swap(a, b)
 local temp = self[a.y][a.x]
 self[a.y][a.x] = self[b.y][b.x]
 self[b.y][b.x] = temp
end

-- Check if two tiles are adjacent
function are_adjacent(a, b)
 return math.abs(a.x - b.x) + math.abs(a.y - b.y) == 1
end

return Grid
