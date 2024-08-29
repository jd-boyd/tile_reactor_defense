lu = require('luaunit')
Set = require('set')

function TestNew()

   p1 = Set:new({'a', 'b'})
   lu.assertEquals(p1, p1)
   
   
end


local r = lu.LuaUnit.run()

os.exit( r )


