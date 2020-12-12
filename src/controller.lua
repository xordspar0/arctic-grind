local controller = {}

function controller.new()
	local self = {}
	setmetatable(self, {__index = controller})

	self:joystickassign()

	return self
end

function controller:isDown(button)
	print(self.type)
	if self.type == "keyboard" then
		return love.keyboard.isDown(self[button])
	elseif self.type == "joystick" then
		return self.joystick:isGamepadDown(self[button])
	end
end

function controller:joystickassign()
	local joysticks = love.joystick.getJoysticks()
	print(#joysticks)
	if #joysticks > 0 then
		self.type = "joystick"
		self.joystick = joysticks[1]

		self.right = "dpright"
		self.left = "dpleft"
		self.jump = "a"
		self.attack = "b"
	else
		self.type = "keyboard"
		self.joystick = nil

		self.right = "right"
		self.left = "left"
		self.jump = "up"
		self.attack = "return"
	end
end

return controller
