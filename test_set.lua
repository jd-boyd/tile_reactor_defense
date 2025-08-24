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

-- Extract and redefine Set class from trd.lua
-- Since Set is defined as local in trd.lua, we'll copy its definition here
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

function TestNew()

   p1 = Set:new({'a', 'b'})
   lu.assertEquals(p1, p1)
   
   
end


-- Run the test functions
print("Running TestNew...")
TestNew()

local r = lu.LuaUnit.run()

os.exit( r )


