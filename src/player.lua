local resources = require("resources")
local controller = require("controller")
local sprite = require("sprite")

local lume = require("vendor/lume")

local player = {}

function player.new(x, y)
	local self = {}
	setmetatable(self, {__index = player})

	self.controller = controller.new()
	self.character = resources.loadCharacter("fox")

	-- Set up innate properties.
	self.width = 54
	self.height = 32
	self.walkingVelocity = 100  -- measured in pixels per second
	self.jumpVelocity = -400
	self.fallAccel = 1500		-- measured in pixels per second per second

	-- Set up values for initial state.
	self.currentFrame = 1
	self.facing = 1				-- 1 = right, -1 = left
	self.x = x
	self.y = y
	self.xVelocity = 0
	self.yVelocity = 0
	self.yAccel = 0

	return self
end

function player:update(dt)
	self:input()
	self.character:update(dt)

	if self:isOnGround() and self.yVelocity > 0 then
		self.yVelocity = 0
		self.yAccel = 0
		self.y = math.floor(self.y / state.level.tileSize) * state.level.tileSize
		if self.character:getAnim() == "jump" then
			self.character:setAnim("stand")
		end
	else
		self.yAccel = self.fallAccel
	end

	if self:isAgainstWall(self.facing) then
		self.xVelocity = 0
	end

	if self:isOnCeiling() and self.yVelocity < 0 then
		self.yVelocity = 0
		self.yAccel = 0
	end

	-- Apply acceleration and velocity; set coordinates accordingly.
	self.yVelocity = self.yVelocity + (self.yAccel * dt)
	self.x = self.x + (self.xVelocity * dt)
	self.y = self.y + (self.yVelocity * dt)
end

function player:draw()
	local x = math.floor(self.x)
	local y = math.floor(self.y)

	self.character:draw(x, y, self.facing)
end

function player:joystickadded()
	self.controller:joystickassign()
end

function player:input()
	if self.controller:isDown("right") or self.controller:isDown("left") then
		if self.controller:isDown("right") then
			self.facing = 1
			self.xVelocity = self.walkingVelocity
		elseif self.controller:isDown("left") then
			self.facing = -1
			self.xVelocity = -self.walkingVelocity
		end
		if self:isOnGround() and
		   self.character:getAnim() ~= "walk" then
			self.character:setAnim("walk")
		end
	else
		self.xVelocity = 0
		if self:isOnGround() and self.character:getAnim() == "walk" then
			self.character:setAnim("stand")
		end
	end

	if self:isOnGround() and self.controller:isDown("jump") then
		self.yVelocity = self.jumpVelocity
	end
	if self.onGround and self.character:getAnim() == "jump" then
		self.character:setAnim("stand")
	end
end

function player:intersects(x, y, width, height)
	return self.x - self.width/2 < x + width and x < self.x + self.width/2 and self.y - self.height < y + height and y < self.y
end

function player:isOnGround()
	return lume.any(
		{
			{self.x, self.y},
			{self.x - self.width/4, self.y},
			{self.x + self.width/4, self.y},
		},
		function(point)
			return state.level:collides(point[1], point[2])
		end
	)
end

function player:isAgainstWall(direction)
	local x = self.x + direction * self.width / 2
	return lume.any(
		{
			{x, self.y - self.height/2},
			{x, self.y - self.height},
		},
		function(point)
			return state.level:collides(point[1], point[2])
		end
	)
end

function player:isOnCeiling()
	return lume.any(
		{
			{self.x, self.y - self.height},
			{self.x - self.width/4, self.y - self.height},
			{self.x + self.width/4, self.y - self.height},
		},
		function(point)
			return state.level:collides(point[1], point[2])
		end
	)
end

return player
