dist = "null"
state = "START"

alpha = 255
speed = 1.5

window = {}
window.width = love.graphics.getWidth()
window.height = love.graphics.getHeight()

start = {}
start.x = window.width / 2
start.y = window.height / 2

score = {}
score.value = 0
score.x = window.width
score.y = window.height
score.alpha = 255

target = {}
target.x = start.x
target.y = start.y
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

	if state == "RUN" then
		score.y = (score.y - 20*dt)
		score.alpha = (score.alpha - 250*dt) 
		target.radius = (target.radius - speed*dt)

		if target.radius <= 0 then
			state = "END_MISSED"
		end
	elseif state == "END_MISSED" then

		if alpha > 0 then
			alpha = (alpha - 500*dt)
		else
			state = "END_DISPLAY"
			love.graphics.setBackgroundColor(0, 0, 0)
		end
	elseif state == "END_DISPLAY" then
		alpha = 0

		if alpha < 255 then
			alpha = (alpha + 500*dt)
		else
			alpha = 255
		end

		target.x = start.x
		target.y = start.y
		target.radius = 150
	end
end

function love.mousepressed(x, y, button)

	if button == 'l' then

		if state == "START" then
			state = "RUN"
		elseif state == "RUN" then

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
				state = "END_MISSED"
			end
		elseif state == "END_DISPLAY" then
			score.value = 0
			speed = 1.5
			state = "START"
		end
	end	
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	end
end

function love.draw()

	if state == "START" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )

		love.graphics.setColor(0, 0, 0)
		love.graphics.print(
			"Click here", target.x - 75, target.y - 15)
	elseif state == "RUN" then

		if score.alpha > 0 then
			love.graphics.setColor(255, 255, 255, score.alpha)
			love.graphics.print(score.value, score.x, score.y)
		end

		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )
	elseif state == "END_MISSED" then

		if alpha > 0 then
			love.graphics.setBackgroundColor(alpha, 0, 0)

			love.graphics.setColor(255, 255, 255, alpha)
			love.graphics.print(score.value, score.x, score.y)
			love.graphics.circle(
				"fill", target.x, target.y, target.radius, 100 )
		end			
		
	elseif state == "END_DISPLAY" then

		love.graphics.setColor(255, 255, 255)
		love.graphics.circle(
			"fill", target.x, target.y, target.radius, 100 )

		love.graphics.setColor(0, 0, 0)
		love.graphics.print(
			"Missed", target.x - 50, target.y - 25)

		if score.value < 10 then 
			love.graphics.print(
				score.value, target.x - 5, target.y + 10)
		else
			love.graphics.print(
				score.value, target.x - 15, target.y + 10)
		end
	end
end
