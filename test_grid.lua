lu = require('luaunit')
Grid = require('grid')



function TestListCompare()
   lu.assertEquals(1, 1)
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


r = lu.LuaUnit.run()

os.exit( r )

