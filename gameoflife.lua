-- Conway's Game of Life
-- Odhrán Roche 27/03/2012
math.randomseed(os.time())
math.random();math.random();math.random()

function north(x, y) return {x-1, y} end
function south(x, y) return {x+1, y} end
function west(x, y)	return {x, y-1} end
function east(x, y) return {x, y+1} end
function northeast(x, y) return {x-1, y+1} end
function northwest(x, y) return {x-1, y-1} end
function southeast(x, y) return {x+1, y+1} end
function southwest(x, y) return {x+1, y-1} end

function createGrid(size)
	local grid = {}
	for i = 1, size do
		local row = {}
		for j = 1, size do
			table.insert(row, 0)
		end
		table.insert(grid, row)
	end
	
	
	return setmetatable(grid, {
		__index = 
		function(t, key)
			if not table[key] then
				return {}
			else
				return table[key]
			end
		end,
		
		__tostring = 
		function(t)
			local temp = {}
			for k, v in ipairs(t) do
				for m, n in ipairs(v) do
					table.insert(temp, n .. " ")
					-- if n == 0 then table.insert(temp, ". ") 
					-- else table.insert(temp, "; ") end
				end
				table.insert(temp, "\r\n")
			end
			
			return table.concat(temp)
		end
	})
	
end

function randomize(grid)
	for k,v in ipairs(grid) do
		for m,n in ipairs(v) do
			-- if math.random(2) == 1 then grid[k][m] = 1 end
			if math.random() < .60 then grid[k][m] = 1 end
		end
	end
end


-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
-- Any live cell with two or three live neighbours lives on to the next generation.
-- Any live cell with more than three live neighbours dies, as if by overcrowding.
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

function tick(grid)
	local update = {}
	for k,v in ipairs(grid) do
		for m,n in ipairs(v) do
			local neighbours = 0
			local directions = {
			north(k,m),south(k,m),east(k,m),west(k,m),
			northwest(k,m), northeast(k,m), southwest(k,m), southeast(k,m)
			}
			for a, b in ipairs(directions) do
				if grid[b[1]][b[2]] then
					if grid[b[1]][b[2]] == 1 then neighbours = neighbours + 1 end
				end
			end
			
			if neighbours < 2 then
				table.insert(update, -1)
			elseif neighbours >= 2 and neighbours < 4 then
				if neighbours == 3 then
					table.insert(update, 1)
				else
					table.insert(update, 0)
				end
			elseif neighbours > 3 then
				table.insert(update, -1)
			end
			
			-- io.write(neighbours .. " ")
		end
		-- print()
	end
	
	local count = 1
	for k,v in ipairs(grid) do
		for m,n in ipairs(v) do
			local x = update[count]
			if x == -1 then
				grid[k][m] = 0
			elseif x == 1 then
				grid[k][m] = 1
			end
			count = count + 1
		end
	end
	print(#grid*#grid, count)
end

function sleep(n)
	os.execute("timeout " .. tonumber(n))
end

local g = createGrid(30)
randomize(g)
for i = 1, 100 do
	print(g)
	-- sleep(1)
	tick(g)
end