local camera = {}

function camera.new(x, y, width, height, mode, trackLength, speed)
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

	if mode == "static" or
		mode == "pan" or
		mode == "vpan" then
		self.mode = mode
	elseif mode == "follow" or
		mode == "path" then
		error(string.format('Camera mode "%s" is not implemented yet', mode))
	else
		error(string.format('"%s" is not a valid camera mode', mode))
	end

	return self
end

function camera:update(dt)
	if self.mode == "pan" then
		if self.x + self.width > self.length or
		   self.x < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
	elseif self.mode == "vpan" then
		if self.y + self.height > self.length or
			self.y < 0 then
			self.speed = -self.speed
		end
		self.y = self.y + self.speed*dt
	end
end

function camera:draw(object)
	love.graphics.push()
	love.graphics.translate(-self.x, -self.y)
	love.graphics.setScissor(self.originX, self.originY, self.width, self.height)

	object:draw()

	love.graphics.setScissor()
	love.graphics.pop()
end

return camera
