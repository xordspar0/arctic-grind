local resources = require("resources")
local controller = require("controller")
local sprite = require("sprite")

local player = {}

function player.new(x, y)
	local self = {}
	setmetatable(self, {__index = player})

	self.controller = controller.new()
	self.character = resources.loadCharacter("fox")

	-- Set up innate properties.
	self.width = 32
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
   return self.x < x + width and x < self.x + self.width and self.y < y + height and y < self.y + self.height
end

function player:isOnGround()
	local isOnGround
	local groundLayer = state.level.gnd
	local tileSize = state.level.tileSize
	local playerColCenter = math.floor(self.x / tileSize)
	local playerColLeft = math.floor((self.x - self.width/4) / tileSize)
	local playerColRight = math.floor((self.x + self.width/4) / tileSize)
	local playerRow = math.floor(self.y / tileSize)

	-- If the player is outside the level, then fall.
	if not groundLayer[playerRow] or not groundLayer[playerRow][playerColCenter] then
		isOnGround = false
	-- Check for ground under the player's feet.
	elseif groundLayer[playerRow][playerColLeft] == 1 or
		groundLayer[playerRow][playerColRight] == 1 then
		isOnGround = true
	else
		isOnGround = false
	end

	return isOnGround
end

function player:isAgainstWall(direction)
	local isAgainstWall
	local groundLayer = state.level.gnd
	local tileSize = state.level.tileSize
	local playerColLeft = math.floor((self.x - self.width/4) / tileSize)
	local playerColRight = math.floor((self.x + self.width/4) / tileSize)
	local playerRow = math.floor((self.y - self.height/2) / tileSize)
	local playerCol

	if direction == 1 then
		playerCol = playerColRight
	elseif direction == -1 then
		playerCol = playerColLeft
	else
		return nil
	end

	-- If the player is outside the level, then there is no collision.
	if not groundLayer[playerRow] or not groundLayer[playerRow][playerCol] then
		isAgainstWall = false
	-- Check for ground on the side of the player.
	elseif groundLayer[playerRow][playerCol] == 1 then
		isAgainstWall = true
	else
		isAgainstWall = false
	end

	return isAgainstWall
end

function player:isOnCeiling()
	local isOnCeiling
	local groundLayer = state.level.gnd
	local tileSize = state.level.tileSize
	local playerColCenter = math.floor(self.x / tileSize)
	local playerColLeft = math.floor((self.x - self.width/4) / tileSize)
	local playerColRight = math.floor((self.x + self.width/4) / tileSize)
	local playerRow = math.floor((self.y-self.height) / tileSize)

	-- If the player is outside the level, then there is no collision.
	if not groundLayer[playerRow] or not groundLayer[playerRow][playerColCenter] then
		isOnCeiling = false
	-- Check for ceiling above the player's head.
	elseif groundLayer[playerRow][playerColLeft] == 1 or
		groundLayer[playerRow][playerColRight] == 1 then
		isOnCeiling = true
	else
		isOnCeiling = false
	end

	return isOnCeiling
end

return player
