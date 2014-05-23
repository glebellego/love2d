dist = "null"
state = "start"

red = 255
speed = 1.5

window = {}
window.width = love.graphics.getWidth()
window.height = love.graphics.getHeight()

score = {}
score.value = 0
score.x = window.width
score.y = window.height
score.alpha = 255

target = {}
target.x = window.width / 2
target.y = window.height / 2
target.radius = 150

function isTouched(x1,y1, x2,y2)
	dist =  ((x2-x1)^2+(y2-y1)^2)^0.5 

	if dist < target.radius then
		return true
	else
		return false
	end
end

function love.load()
	font = love.graphics.newFont(30)
	love.graphics.setFont(font)
end

function love.update(dt)

	if state == "run" then
		score.y = (score.y - 20*dt)
		score.alpha = (score.alpha - 250*dt) 
		target.radius = (target.radius - speed*dt)

		if target.radius <= 0 then
			state = "end"
		end
	elseif state == "end" then
		red = (red - 500*dt)
		if red <= 0 then
			love.event.push("quit")
		end
	end
end

function love.mousepressed(x, y, button)

	if button == 'l' then

		if state == "start" then
			state = "run"
		elseif state == "run" then

			if isTouched(target.x, target.y, x, y) then
				--Target touched
				score.value = score.value + 1
				score.x = target.x
				score.y = target.y
				score.alpha = 255

				speed = speed + 5

				target.radius = 150
				target.x = love.math.random(0, window.width)
				target.y = love.math.random(0, window.height)
			else
				--Target missed
				state = "end"
			end
		elseif state == "end" then

		end
	end	
end	

function love.draw()

	if state == "start" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )

		love.graphics.setColor(0, 0, 0)
		love.graphics.print(
			"Click here", target.x - 75, target.y - 15)
	elseif state == "run" then

		if score.alpha > 0 then
			love.graphics.setColor(255, 255, 255, score.alpha)
			love.graphics.print(score.value, score.x, score.y)
		end

		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )
	elseif state == "end" then
		love.graphics.setBackgroundColor(red, 0, 0)

		if score.alpha > 0 then
			love.graphics.setColor(255, 255, 255, score.alpha)
			love.graphics.print(score.value, score.x, score.y)
		end

		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )
	end
end
