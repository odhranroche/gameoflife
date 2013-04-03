require "gameoflife"

function love.load()
	GRIDSIZE = 32
	GRID = createGrid(GRIDSIZE)
	randomize(GRID)
	RANDCOLOUR1 = {math.random(255),math.random(255),math.random(255)} -- filled cells
	RANDCOLOUR2 = {math.random(255),math.random(255),math.random(255)} -- empty cells
	CELLSIZE = 10
	XOFFSET = 15
	YOFFSET = 15
	
	GO = false
	
	GRIDCOORDS = {} -- {1,1},{1,2},{1,3}...
	DRAWCOORDS = {} -- {15,15},{15,40} ...
	
	local x, y = XOFFSET, YOFFSET
	for i = 1, GRIDSIZE do
		for j = 1, GRIDSIZE do
			table.insert(DRAWCOORDS, {x, y})
			table.insert(GRIDCOORDS, {i, j})
			x = x + XOFFSET
		end
		x, y = XOFFSET, y + YOFFSET
	end
	
	local font = love.graphics.newFont(24)
	love.graphics.setFont(font)
end

function love.update(dt)
	if GO or love.keyboard.isDown(" ") then
		love.timer.sleep(0.05)
		tick(GRID)
	else
		love.timer.sleep(0.01)
	end
end

function love.draw()
	local count = 1
	-- draw the cells
	for element in twod.iterateElements(GRID) do
		if element == 1 then
			love.graphics.setColor(RANDCOLOUR1)
		else
			love.graphics.setColor(RANDCOLOUR2)
		end
		love.graphics.rectangle("fill", DRAWCOORDS[count][1], DRAWCOORDS[count][2], CELLSIZE, CELLSIZE)
		count = count + 1
	end
	
	-- menu
	love.graphics.setColor(130,130,130)
	love.graphics.rectangle("fill", 505, 15, 120, 50)  -- start
	love.graphics.rectangle("fill", 505, 75, 120, 50)  -- pause
	love.graphics.rectangle("fill", 505, 135, 120, 50) -- step
	love.graphics.rectangle("fill", 505, 195, 120, 50) -- clear
	love.graphics.rectangle("fill", 505, 255, 120, 50) -- reset
	love.graphics.rectangle("fill", 505, 315, 120, 50) -- quit
	love.graphics.rectangle("fill", 505, 440, 120, 50) -- colour
	
	love.graphics.setColor(255,255,255,250)
	love.graphics.print("Start", 534, 25)
	love.graphics.print("Pause", 531, 85)
	love.graphics.print("Step", 538, 145)
	love.graphics.print("Clear", 535, 205)
	love.graphics.print("Reset", 534, 265)
	love.graphics.print("Quit", 539, 325)
	love.graphics.print("Colour", 526, 450)
end

function love.keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	elseif key == "r" then
		randomize(GRID)
	elseif key == "return" then -- step
		tick(GRID)
	elseif key == "backspace" then -- clear
		clear(GRID)
	elseif key == "p" then -- pause
		GO = false
	elseif key == "s" then -- start
		GO = true
	elseif key == "c" then -- colour
		RANDCOLOUR1 = {math.random(255),math.random(255),math.random(255)}
		RANDCOLOUR2 = {math.random(255),math.random(255),math.random(255)}
	end
end

function flip(bit)
	if not (bit == 1 or bit == 0) then error("Cannot flip this data.") end
	if bit == 1 then return 0 else return 1 end
end

function love.mousepressed(x, y)
	if x > 505 and x < 625 and y > 15 and y < 65 then -- start
		GO = true
	elseif x > 505 and x < 625 and y > 75 and y < 125 then -- pause
		GO = false
	elseif x > 505 and x < 625 and y > 135 and y < 185 then -- step
		tick(GRID)
	elseif x > 505 and x < 625 and y > 195 and y < 245 then -- reset
		clear(GRID)
	elseif x > 505 and x < 625 and y > 255 and y < 305 then -- quit
		randomize(GRID)
	elseif	x > 505 and x < 625 and y > 315 and y < 360 then
		love.event.push("quit")
	elseif x > 505 and x < 625 and y > 440 and y < 490 then -- colour
		RANDCOLOUR1 = {math.random(255),math.random(255),math.random(255)}
		RANDCOLOUR2 = {math.random(255),math.random(255),math.random(255)}
	else
	-- flip a cell if clicked
		for k, v in ipairs(DRAWCOORDS) do
			if x > v[1] and x < v[1]+CELLSIZE and y > v[2] and y < v[2]+CELLSIZE then
				GRID[GRIDCOORDS[k][1]][GRIDCOORDS[k][2]] = flip(GRID[GRIDCOORDS[k][1]][GRIDCOORDS[k][2]])
			end
		end
	end
end