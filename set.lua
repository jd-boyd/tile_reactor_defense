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


return Set
