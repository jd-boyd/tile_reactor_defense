-- Simple test framework to replace luaunit
local lu = {}
lu.LuaUnit = {}

local tests_run = 0
local tests_passed = 0

function lu.assertEquals(actual, expected)
    tests_run = tests_run + 1
    if actual == expected then
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

-- Extract and redefine Pt class from trd.lua
-- Since Pt is defined as local in trd.lua, we'll copy its definition here
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

function TestEquals()

   p1 = Pt:new({x = 2, y = 3})
   p2 = Pt:new(2, 3)   

   lu.assertEquals(p1, p2)
   
   p3 = Pt:new(4, 6)

   lu.assertNotEquals(p1, p3)   
   
end


function TestTs()

   p1 = Pt:new({x = 2, y = 3})
   p2 = Pt:new(2, 3)   

   lu.assertEquals(tostring(p1), "Pt{2, 3}")
  
  
end



-- Run the test functions
print("Running TestEquals...")
TestEquals()

print("Running TestTs...")
TestTs()

local r = lu.LuaUnit.run()

os.exit( r )


