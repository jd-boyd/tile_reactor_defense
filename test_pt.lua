lu = require('luaunit')
Pt = require('pt')

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



local r = lu.LuaUnit.run()

os.exit( r )


