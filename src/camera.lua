local camera = {}

function camera.new(x, y, width, height, trackLength, speed)
	local self = {}
	setmetatable(self, {__index = camera})

	self.x = x - width / 2
	self.y = y - height / 2
	self.width = width
	self.height = height
	self.length = trackLength
	self.speed = speed

	return self
end

function camera:update(dt)
	if state.debug then return end

	self.y = self.y - dt*self.speed
end

function camera:draw(object)
	love.graphics.push()
	love.graphics.translate(math.floor(-self.x), math.floor(-self.y))

	object:draw()

	love.graphics.pop()
end

function camera:getArea()
	return self.x, self.y, self.width, self.height
end

return camera
