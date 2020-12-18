local resources = require("resources")
local sprite = require("sprite")

local Fox = {}
Fox.__index = Fox

Fox.animations = {
	jump = sprite.new(
		resources.loadSprite("fox", "fox.png"),
		{                       -- List of all of frames in the animation.
			{x = 0, y = 0},
		},
		64, 64, 0,              -- The width and height of each frame, how high the feet are in that frame.
		0,                      -- The frames per second of this animation.
		false                   -- Whether this animation loops.
	),

	stand = sprite.new(
		resources.loadSprite("fox", "fox.png"),
		{
			{x = 0, y = 0},
		},
		64, 64, 0,
		0,
		false
	),

	walk = sprite.new(
		resources.loadSprite("fox", "fox.png"),
		{
			{x = 64, y = 0},
			{x = 128, y = 0},
			{x = 192, y = 0},
			{x = 0, y = 0},
		},
		64, 64, 0,
		5,
		true
	),

	scrunched = sprite.new(
		resources.loadSprite("fox", "fox.png"),
		{
			{x = 0, y = 64},
			{x = 64, y = 64},
		},
		64, 64, 0,
		10,
		false
	),
}

Fox.currentAnim = Fox.animations.stand
Fox.currentAnimName = "stand"
Fox.animationOver = false

function Fox:getAnim()
	return self.currentAnimName
end

function Fox:setAnim(animation)
	self.currentAnim = self.animations[animation]
	self.currentAnimName = animation
	self.animationOver = false
	self.currentAnim:resetFrame()
end

function Fox:update(dt)
	self.currentAnim:update()

	-- If this is the last frame of the animation, check to see if we should do
	-- anything.
	if self.currentAnim:atLastFrame() and self.currentAnim.loop == false then
		self.animationOver = true
	end
end

function Fox:draw(x, y, facing)
	self.currentAnim:draw(x, y, facing)
end

return setmetatable({}, Fox)
