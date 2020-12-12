local camera = {}

function camera.new(x, y, width, height, trackLength, speed)
	local self = {}
	setmetatable(self, {__index = camera})

	self.originX = x
	self.originY = y
	self.x = 0
	self.y = 0
	self.width = width
	self.height = height
	self.length = trackLength
	self.speed = speed

	return self
end

function camera:update(dt)
end

function camera:draw(object)
	love.graphics.push()
	love.graphics.translate(-self.x, -self.y)
	love.graphics.setScissor(self.originX, self.originY, self.width, self.height)

	object:draw()

	love.graphics.setScissor()
	love.graphics.pop()
end

function camera:getArea()
	return self.x, self.y, self.width, self.height
end

return camera
