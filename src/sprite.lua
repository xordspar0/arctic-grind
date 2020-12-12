local sprite = {}

function sprite.new(image, frames, frameWidth, frameHeight, feetHeight, fps)
	local self = {}
	setmetatable(self, {__index = sprite})

	self.image = image
	self.numFrames = #frames
	self.frameWidth = frameWidth
	self.frameHeight = frameHeight
	self.feetHeight = feetHeight
	self.framesPerSecond = fps

	self.frames = {}
	for i, frame in ipairs(frames) do
		self.frames[i] = love.graphics.newQuad(
			frame.x, frame.y, self.frameWidth, self.frameHeight,
			self.image:getDimensions()
		)
	end
	self:resetFrame()

	return self
end

function sprite:atLastFrame()
	return self.currentFrame == self.numFrames
end

function sprite:resetFrame()
	self.startTime = love.timer.getTime()
	self.currentFrame = math.floor(
		(self.framesPerSecond * (love.timer.getTime() - self.startTime))
		% self.numFrames) + 1
end

function sprite:update(dt)
	self.currentFrame = math.floor(
		(self.framesPerSecond * (love.timer.getTime() - self.startTime))
		% self.numFrames) + 1
end

function sprite:draw(x, y, facing)
	love.graphics.draw(
		self.image, self.frames[self.currentFrame],
		x, y,
		0, facing, 1, self.frameWidth/2, self.frameHeight - self.feetHeight)
end

return sprite
