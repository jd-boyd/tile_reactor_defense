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
   -- print('PT:n')
   
   -- print('PT tx: ' .. type(x))
   -- print('PT ty: ' .. type(y))  
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
   -- Check if all elements in set A are in set B

   print('PT_e at: ' .. type(a))
   print('PT_e bt: ' .. type(b))   
   
   if type(a) ~= "table" or type(b) ~= "table" then
      print("NT")
      return false
   end
   
   return a.x == b.x and a.y == b.y
end


return Pt
