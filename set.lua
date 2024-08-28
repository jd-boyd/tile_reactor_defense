function Set (list)
   local set = {}
   for _, l in ipairs(list) do set[l] = true end
   return set
end

function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

return Set
