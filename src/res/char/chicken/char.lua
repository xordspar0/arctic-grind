local resources = require("resources")
local sprite = require("sprite")

local Chicken = {}
Chicken.__index = Chicken

Chicken.animations = {
	jump = {
		sprite = sprite.new(
			resources.loadSprite("chicken", "chicken_walk.png"),
			{						-- List of all of frames in the animation.
				{x = 32, y = 96},
			},
			32, 32, 4,				-- The width and height of each frame, how high the feet are in that frame.
			5						-- The frames per second of this animation.
		),
		loop = true
	},

	stand = {
		sprite = sprite.new(
			resources.loadSprite("chicken", "chicken_walk.png"),
			{
				{x = 0, y = 96},
			},
			32, 32, 4,
			5
		),
		loop = true
	},

	walk = {
		sprite = sprite.new(
			resources.loadSprite("chicken", "chicken_walk.png"),
			{
				{x = 32, y = 96},
				{x = 64, y = 96},
				{x = 96, y = 96},
				{x = 0, y = 96},
			},
			32, 32, 4,
			5
		),
		loop = true
	}
}

Chicken.currentAnim = Chicken.animations.stand
Chicken.currentAnimName = "stand"
Chicken.animationOver = false

function Chicken:getAnim()
	return self.currentAnimName
end

function Chicken:setAnim(animation)
	if self.animations[animation] then
		self.currentAnim = self.animations[animation]
		self.currentAnimName = animation
		self.animationOver = false
		self.currentAnim.sprite:resetFrame()
	end
end

function Chicken:update(dt)
	self.currentAnim.sprite:update()

	-- If this is the last frame of the animation, check to see if we should do
	-- anything.
	if self.currentAnim.sprite:atLastFrame() and self.currentAnim.loop == false then
		self.animationOver = true
	end
end

function Chicken:draw(x, y, facing)
	self.currentAnim.sprite:draw(x, y, facing)
end

return setmetatable({}, Chicken)
