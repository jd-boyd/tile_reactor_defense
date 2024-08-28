Set = {}
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

return Set
