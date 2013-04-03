-- Copyright (c) 2013 Odhrán Roche
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- A module for creating and using 2D square grids
-- Includes functions for initialising the gird, getting and setting elements, 
-- randomising the grid, getting the size of the grid, getting 4 or 8 neighbours
-- and iterators for looping through elements or coordinates

twod = {}
math.randomseed(os.time())

-- create new 2D array
-- takes an optional filler, default is 0
function twod.new(size, fill)
	local fill = fill and fill or 0
	local grid = {}
	for i = 1, size do
		local row = {}
		for j = 1, size do
			table.insert(row, fill)
		end
		table.insert(grid, row)
	end
	
	-- for printing
	return setmetatable(grid, {
		__tostring = 
		function(t)
			local temp = {}
			for k, v in ipairs(t) do
				for m, n in ipairs(v) do
					table.insert(temp, tostring(n).." ")
				end
				table.insert(temp, "\r\n")
			end
			
			return table.concat(temp)
		end
	})
end

-- return size of 2D array
function twod.size(grid)
	return #grid
end

-- fill the 2D array with random elements
-- set is a table of the elements e.g {0, 1}
function twod.randomize(grid, set)
	assert(#set > 0, "Random set empty.")
	for k,v in ipairs(grid) do
		for m, n in ipairs(v) do
			grid[k][m] = set[math.random(#set)]
		end
	end
end

-- return the element at x, y
function twod.get(grid, cell)
	local element = grid[cell[1]] and grid[cell[1]][cell[2]]
	return element
end

-- set the cell at x, y to element
function twod.set(grid, cell, element)
	local something = twod.get(grid, cell)
	if something then
		grid[cell[1]][cell[2]] = element
	end
end

-- set all the cells to element
function twod.setAll(grid, element)
	for k,v in ipairs(grid) do 
		for m,n in ipairs(v) do
			grid[k][m] = element
		end
	end
end

-- helper functions for neighbour queries
-- coords are {row, column} format
local function north(cell)     return 	{cell[1]-1, cell[2]} end
local function south(cell)     return 	{cell[1]+1, cell[2]} end
local function west(cell)      return 	{cell[1],   cell[2]-1} end
local function east(cell)      return 	{cell[1],   cell[2]+1} end
local function northeast(cell) return 	{cell[1]-1, cell[2]+1} end
local function northwest(cell) return 	{cell[1]-1, cell[2]-1} end
local function southeast(cell) return 	{cell[1]+1, cell[2]+1} end
local function southwest(cell) return 	{cell[1]+1, cell[2]-1} end
local directions = {north, south, east, west, northeast, northwest, southeast, southwest}

-- return a table containing 4 or 8 neighbours
-- table returned is in the form {{1,1} = 1, {2,1} = 0 ... }
function twod.getNeighbours(grid, cell, numAxis)
	assert((numAxis == 4 or numAxis == 8), "Incorrect number of neighbours.")
	local neighbours = {}
	for i = 1, numAxis do
		local dir = directions[i](cell) -- coords of neighbour
		neighbours[dir] = twod.get(grid, dir) -- set to the neighbour element at coords
	end
	return neighbours
end

-- iterate through elements in 2D array
-- use in a loop e.g for e in twod.iterateElements(g) do print(e) end
function twod.iterateElements(grid)
	local i, j = 0, 1
	local n = #grid
	return function()
				if i == n and j <= n then
					i = 0
					j = j + 1 
				end
				i = i + 1
				if i <= n and j <= n then return grid[j][i] end
			end
end

-- iterate through coordinates of 2D array
-- use in a loop e.g for e in twod.iterateCoords(g) do print(e[1],e[2]) end
function twod.iterateCoords(grid)
	local i, j = 0, 1
	local n = #grid
	return function()
				if i == n and j <= n then
					i = 0
					j = j + 1 
				end
				i = i + 1
				if i <= n and j <= n then return {j,i} end
			end
end

return twod