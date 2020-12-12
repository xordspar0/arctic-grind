local controller = {}

function controller.new(controllerType)
	local self = {}
	setmetatable(self, {__index = controller})

	self.type = controllerType

	if self.type == "keyboard" then
		self.right = "right"
		self.left = "left"
		self.jump = "up"
		self.attack = "return"
	end

	return self
end

function controller:isDown(button)
	if self.type == "keyboard" then
		if button == "right" then
			return love.keyboard.isDown(self.right)
		elseif button == "left" then
			return love.keyboard.isDown(self.left)
		elseif button == "jump" then
			return love.keyboard.isDown(self.jump)
		elseif button == "attack" then
			return love.keyboard.isDown(self.attack)
		end
	end
end

return controller
