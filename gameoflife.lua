-- Conway's Game of Life
-- Odhrán Roche 27/03/2012
math.randomseed(os.time())
math.random();math.random();math.random()

local twod = require "twodimensionalarray"

function createGrid(size)
	return twod.new(size)
end

function randomize(grid)
	twod.randomize(grid, {1,0})
end

function clear(grid)
	twod.setAll(grid, 0)
end

-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
-- Any live cell with two or three live neighbours lives on to the next generation.
-- Any live cell with more than three live neighbours dies, as if by overcrowding.
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
function tick(grid)
	local update = {}
	for cell in twod.iterateCoords(grid) do
		-- count number of neighbours
		local neighbours = 0
		for _, b in pairs(twod.getNeighbours(grid, cell, 8)) do
			neighbours = neighbours + b
		end

		-- buffer the updates to be made
		-- -1 die, 0 do nothing, 1 become alive
		if neighbours < 2 then -- die from underpopulation
			table.insert(update, -1)
		elseif neighbours >= 2 and neighbours < 4 then
			if neighbours == 3 then
				table.insert(update, 1) -- go from dead to alive, or keep living if already alive
			else
				table.insert(update, 0) -- twod.get(grid, cell)) -- stay in same state
			end
		elseif neighbours > 3 then
			table.insert(update, -1) -- die from over population
		end
	end
	
	-- apply updates to world
	local count = 1
	for cell in twod.iterateCoords(grid) do
		local x = update[count]
		if x == -1 then
			twod.set(grid, cell, 0)
		elseif x == 1 then
			twod.set(grid, cell, 1)
		end
		count = count + 1
	end
end