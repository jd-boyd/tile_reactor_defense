-- Simple test framework to replace luaunit
local lu = {}
lu.LuaUnit = {}

local tests_run = 0
local tests_passed = 0

-- Deep table comparison helper function
local function tables_equal(t1, t2, visited)
    visited = visited or {}
    
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return t1 == t2
    end
    
    -- Avoid infinite recursion
    if visited[t1] then return visited[t1] == t2 end
    visited[t1] = t2
    
    -- Check all keys in t1 exist in t2 with equal values
    for k, v in pairs(t1) do
        -- Skip metatable-related keys to avoid circular references
        if k ~= "__index" and not tables_equal(v, t2[k], visited) then
            return false
        end
    end
    
    -- Check all keys in t2 exist in t1 with equal values
    for k, v in pairs(t2) do
        -- Skip metatable-related keys to avoid circular references
        if k ~= "__index" and not tables_equal(v, t1[k], visited) then
            return false
        end
    end
    
    return true
end

function lu.assertEquals(actual, expected)
    tests_run = tests_run + 1
    if tables_equal(actual, expected) then
        tests_passed = tests_passed + 1
        print("✓ PASS")
    else
        print("✗ FAIL: expected " .. tostring(expected) .. ", got " .. tostring(actual))
    end
end

function lu.assertNotEquals(actual, expected)
    tests_run = tests_run + 1
    if actual ~= expected then
        tests_passed = tests_passed + 1
        print("✓ PASS")
    else
        print("✗ FAIL: expected " .. tostring(actual) .. " to not equal " .. tostring(expected))
    end
end

function lu.assertTrue(actual)
    tests_run = tests_run + 1
    if actual then
        tests_passed = tests_passed + 1
        print("✓ PASS")
    else
        print("✗ FAIL: expected true, got " .. tostring(actual))
    end
end

function lu.assertFalse(actual)
    tests_run = tests_run + 1
    if not actual then
        tests_passed = tests_passed + 1
        print("✓ PASS")
    else
        print("✗ FAIL: expected false, got " .. tostring(actual))
    end
end

function lu.LuaUnit.run()
    print("\nTest Results: " .. tests_passed .. "/" .. tests_run .. " passed")
    if tests_passed == tests_run then
        print("All tests passed!")
        return 0
    else
        print("Some tests failed!")
        return 1
    end
end

-- Constants from trd.lua
GRID_WIDTH = 7
GRID_HEIGHT = 8

-- Extract and redefine Set class from trd.lua
local Set = {}

function Set:new (list)
   o = {set = {}}
   setmetatable(o, self)
   self.__index = self

   for _, l in ipairs(list) do o.set[l] = true end
  return o
end

function Set:to_list()
  local keys={}
  for key,_ in pairs(self.set) do
    table.insert(keys, key)
  end
  return keys
end

function Set:compare(other)
    -- Check if all elements in set A are in set B
    for key in pairs(self.set) do
        if other.set[key] ~= true then
            return false -- A key in set A is not in set B
        end
    end

    -- Check if all elements in set B are in set A
    for key in pairs(other.set) do
        if self.set[key] ~= true then
            return false -- A key in set B is not in set A
        end
    end

    return true -- All keys matched in both sets
end

function Set.__eq(a, b)
   -- Check if all elements in set A are in set B
   local ret = a:compare(b)
   print("S_e: " .. tostring(ret))
   return ret
end

-- Extract and redefine Pt class from trd.lua
local Pt = {}
local points = {}
setmetatable(points, {__mode = "v"})  -- make values weak

function Pt:new (x, y)
   local key
   if type(x) == "table" then
      key = x.x .. "-" .. x.y
   else
      key = x .. "-" .. y
   end

   if points[key] then return points[key] end

   o = {}
   setmetatable(o, self)
   self.__index = self

   if type(x) == "table" then
      o.x = x.x
      o.y = x.y
   else
      o.x = x or 0
      o.y = y or 0
   end

   points[key] = o

   return o
end

function Pt:toarray()
   return {self.x, self.y}
end

function Pt.__eq(a, b)
   print('PT_e at: ' .. type(a))
   print('PT_e bt: ' .. type(b))

   if type(a) ~= "table" or type(b) ~= "table" then
      print("NT")
      return false
   end

   return a.x == b.x and a.y == b.y
end

function Pt:__tostring()
   return "Pt{" .. self.x .. ", " .. self.y .. "}"
end

-- Extract and redefine Grid class from trd.lua
local Grid = {height=GRID_HEIGHT, width=GRID_WIDTH}

function Grid:new (w, h)
   o = {   height = h,
	   width = w,
	   tile_cnt=0
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

function Grid:init(tile_cnt)
   self.tile_cnt = tile_cnt
   for y=1, self.height do
      for x=1, self.width do
	 local r =  math.random(1, tile_cnt) -- Six types of tiles
	 self[y][x] = r
      end
   end
end

function Grid:test()
   for y=1, self.height do
      for x=1, self.width do
	 local r = self[y][x]
	 assert (r ~= 0)
      end
   end
end

function Grid:find_matches()
  local matches = {}
  for y=1, self.height do
    for x=1, self.width do
      local tile = self[y][x]
      if x <= self.width - 2 and self[y][x+1] == tile and self[y][x+2] == tile then
        table.insert(matches, Pt:new(x,y))
	table.insert(matches, Pt:new{x=x+1, y=y})
	table.insert(matches, Pt:new{x=x+2, y=y})
      end
      if y <= self.height - 2 and self[y+1][x] == tile and self[y+2][x] == tile then
	 table.insert(matches, Pt:new{x=x, y=y})
	 table.insert(matches, Pt:new{x=x, y=y+1})
	 table.insert(matches, Pt:new{x=x, y=y+2})
      end
    end
  end
  match_set = Set:new(matches)
  return match_set:to_list()
end

function Grid:remove_cell(p)
   for y=p.y, 2, -1 do
      self[y][p.x] = self[y-1][p.x]
   end
   local r = math.random(1, self.tile_cnt)
   self[1][p.x] = r
end

-- Remove matches and fill the grid
function Grid:remove_matches(matches)
 for _, match in ipairs(matches) do
    self:remove_cell(match)
 end
end

function Grid:get(p)
   return self[p.y][p.x]
end

function Grid:set(p, v)
   self[p.y][p.x] = v
end

function Grid:allow_swap(a, b)
   if not self:are_adjacent(a, b) then
      return {false, {}}
   end
   self:swap(a, b)
   local matches = self:find_matches()
   print("Gas m: " .. #matches)
   self:swap(a, b)
   if #matches > 0 then
      return {true, matches}
   end
   return {false, {}}
end

-- Swap tiles
function Grid:swap(a, b)
   local temp = self:get(a)
   self[a.y][a.x] = self:get(b)
   self[b.y][b.x] = temp
end

-- Check if two tiles are adjacent
function Grid:are_adjacent(a, b)
 return math.abs(a.x - b.x) + math.abs(a.y - b.y) == 1
end

function TestNew()
   g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   
   
   for y=1, 3 do
      for x=1, 3 do
	 lu.assertEquals(g[y][x], 0)
      end
   end
end

function TestSwapDown()
   g = Grid:new(3, 3)
   
   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   
   
   g[1] = {1, 2, 3}
   g[2] = {4, 5, 6}
   g[3] = {7, 8, 9}
   
   g:swap({x= 2, y=2},
      {x= 2, y=3})
   
   row2 = g[2]
   row3 = g[3]
   
   lu.assertEquals(row2, {4,8, 6})
   lu.assertEquals(row3, {7,5, 9})   
end

function TestSwapRight()
   g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   

   g[1] = {1, 2, 3}
   g[2] = {4, 5, 6}
   g[3] = {7, 8, 9}

   g:swap(Pt:new{x= 2, y=2},
	  Pt:new{x= 3, y=2})

   row2 = g[2]
   
   lu.assertEquals(row2, {4,6, 5})
end

function TestFindMatchesMinimalVert()
   local g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   

   g[1] = {1, 2, 3}
   g[2] = {1, 5, 6}
   g[3] = {1, 8, 9}

   local ret = g:find_matches()

   lu.assertEquals(Set:new(ret),
		   Set:new
		   {Pt:new{x=1, y=1},
		    Pt:new{x=1, y=2},
		    Pt:new{x=1, y=3}})
end

function TestFindMatches5Vert()
   local g = Grid:new(5, 5)

   g[1] = {1, 2, 3, 4, 5}
   g[2] = {1, 5, 6, 4, 5}
   g[3] = {1, 8, 9, 5, 4}
   g[4] = {1, 2, 3, 4, 5}
   g[5] = {1, 8, 4, 4, 5}   

   local ret = g:find_matches()

   lu.assertEquals(getmetatable(ret[1]), Pt)
   
   lu.assertEquals(Set:new(ret),
		   Set:new{
		      Pt:new{x=1, y=1},
		      Pt:new{x=1, y=2},
		      Pt:new{x=1, y=3},
		      Pt:new{x=1, y=4},
		      Pt:new{x=1, y=5}
		   }
   )
end


function TestFindMatchesMinimalHorz()
   local g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   

   g[1] = {1, 1, 1}
   g[2] = {4, 5, 6}
   g[3] = {1, 8, 9}

   local ret = g:find_matches()

   lu.assertEquals(Set:new(ret),
		   Set:new({Pt:new{x=1, y=1},
			    Pt:new{x=2, y=1},
			    Pt:new{x=3, y=1}})
   )
end

function TestFindMatchesL()
   local g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   

   g[1] = {1, 1, 1}
   g[2] = {4, 5, 1}
   g[3] = {1, 8, 1}

   local ret = g:find_matches()

   lu.assertEquals(Set:new(ret),
		   Set:new({Pt:new{x=1, y=1},
			    Pt:new{x=2, y=1},
			    Pt:new{x=3, y=1},
			    Pt:new{x=3, y=2},
			    Pt:new{x=3, y=3},
		   })
   )
end


function TestRemoveCell()
   local g = Grid:new(3, 3)

   lu.assertEquals(g.height, 3)
   lu.assertEquals(g.width, 3)   
   g.tile_cnt = 1
   g[1] = {1, 2, 3}
   g[2] = {4, 5, 6}
   g[3] = {7, 8, 9}

   g:remove_cell(Pt:new(2, 3))

   lu.assertEquals(g[3], {7, 5, 9})
   lu.assertEquals(g[2], {4, 2, 6})   
   lu.assertEquals(g[1], {1, 1, 3})   
end


function TestAreAdjacent()
   local g = Grid:new(3, 3)

   g[1] = {1, 2, 3}
   g[2] = {1, 5, 6}
   g[3] = {1, 8, 9}

   lu.assertTrue(g:are_adjacent(Pt:new(1,1),
				Pt:new(1,2)
			       )
   )
   
   lu.assertTrue(g:are_adjacent(Pt:new(1,1),
				Pt:new(2,1)
   ))
   
   lu.assertFalse(g:are_adjacent(Pt:new(1,1),
				Pt:new(1,1)
   ))
   
   lu.assertFalse(g:are_adjacent(Pt:new(1,1),
				Pt:new(2,2)
   ))
         
end

function TestAllowSwap()
   local g = Grid:new(3, 3)

   g[1] = {1, 2, 3}
   g[2] = {1, 5, 6}
   g[3] = {7, 1, 9}


   --g[3] = {7, 1, 9}
   g:swap(Pt:new(2,3),
	  Pt:new(1,3))
   lu.assertEquals(g[3], {1, 7, 9})

   g:swap(Pt:new(2,3),
	  Pt:new(1,3))
   lu.assertEquals(g[3], {7, 1, 9})

   lu.assertEquals(g:allow_swap(Pt:new(2,3),
				Pt:new(1,3)
			       ),
		   {true, {Pt:new{x=1, y=1}, Pt:new{x=1, y=2}, Pt:new{x=1, y=3}}}
   )

   lu.assertEquals(g:allow_swap(Pt:new(1,3),
				Pt:new(2,3)
			       ),
		   {true, {Pt:new{x=1, y=1}, Pt:new{x=1, y=2}, Pt:new{x=1, y=3}}}
   )

   
   lu.assertEquals(g:allow_swap(Pt:new(1,1),
			       Pt:new(2,1)
			       ),
		   {false, {}}
   )
   
   lu.assertEquals(g:allow_swap(Pt:new(2,1),
				Pt:new(2,2)
			       ),
		   {false, {}}
   )
   
end



-- Run all test functions
print("Running TestNew...")
TestNew()

print("Running TestSwapDown...")
TestSwapDown()

print("Running TestSwapRight...")
TestSwapRight()

print("Running TestFindMatchesMinimalVert...")
TestFindMatchesMinimalVert()

print("Running TestFindMatches5Vert...")
TestFindMatches5Vert()

print("Running TestFindMatchesMinimalHorz...")
TestFindMatchesMinimalHorz()

print("Running TestFindMatchesL...")
TestFindMatchesL()

print("Running TestRemoveCell...")
TestRemoveCell()

print("Running TestAreAdjacent...")
TestAreAdjacent()

print("Running TestAllowSwap...")
TestAllowSwap()

local r = lu.LuaUnit.run()
os.exit( r )


