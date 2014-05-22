	cursor = {}
	cursor.x = 0
	cursor.y = 0

	dist = "null"

	score = 0
	speed = 10

	window = {}
	window.width = love.graphics.getWidth()
	window.height = love.graphics.getHeight()

	target = {}
	target.x = window.width / 2
	target.y = window.height / 2
	target.radius = 100

function love.load()

end

function getDist(x1,y1, x2,y2)
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end

function love.update(dt)
	target.radius = (target.radius - speed*dt)

	if target.radius <= 0 then
		love.event.push("quit")
	end
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		dist = getDist(target.x, target.y, x, y)

		cursor.x = x
		cursor.y = y

		if dist < target.radius then
			score = score + 1
			speed = speed + 5

			target.radius = 100
			target.x = love.math.random(0, window.width)
			target.y = love.math.random(0, window.height)
		else
			love.event.push("quit")
		end
	end	
end	

function love.draw()
	love.graphics.print("score: "..score, 20, 20)

	love.graphics.print("target: "..target.x..", "..target.y, 20, 30)
	love.graphics.print("cursor: "..cursor.x..", "..cursor.y, 20, 40)
	love.graphics.print("dist: "..dist, 20, 50)

	love.graphics.circle( "fill", target.x, target.y, target.radius, 100 )
end
