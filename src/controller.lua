local controller = {}

function controller.new()
	local self = {}
	setmetatable(self, {__index = controller})

	self:joystickassign()

	return self
end

function controller:isDown(button)
	if self.type == "keyboard" then
		return love.keyboard.isDown(self[button])
	elseif self.type == "joystick" then
		return self.joystick:isGamepadDown(self[button]) or self:isJoystickDir(button)
	end
end

function controller:joystickassign()
	local joysticks = love.joystick.getJoysticks()
	if #joysticks > 0 then
		self.type = "joystick"
		self.joystick = joysticks[1]

		self.right = "dpright"
		self.left = "dpleft"
		self.jump = "a"
	else
		self.type = "keyboard"
		self.joystick = nil

		self.right = "right"
		self.left = "left"
		self.jump = "up"
	end
end

function controller:isJoystickDir(direction)
	value = self.joystick:getGamepadAxis("leftx")

	if direction == "right" then
		return value > 0.2
	end

	if direction == "left" then
		return value < -0.2
	end

	return false
end

return controller
