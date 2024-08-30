lu = require('luaunit')
Grid = require('grid')
Set = require('set')
Pt = require('pt')

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


local r = lu.LuaUnit.run()
os.exit( r )


