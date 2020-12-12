local camera = require("camera")
local player = require("player")
local level = require("level")

-- Alias unpack to table.unpack for Lua 5.1 and older.
if not table.unpack then
	table.unpack = unpack
end

state = {}

function love.load()
	levelName = "default"
	for i, flag in ipairs(arg) do
		if flag == "--level" and arg[i+1] then
			levelName = arg[i+1]
		end
	end

	state.level, err = level.new(levelName)
	if err then
		error(err)
	end

	if state.level.music then
		state.level.music:play()
	end

	state.activeCamera = camera.new(
		0, 0,
		love.graphics.getWidth(), love.graphics.getHeight(),
		state.level.height, 10
	)

	state.players = {}
	state.players[1] = player.new(200, 10)
end

function love.update(dt)
	state.activeCamera:update(dt)

	local cameraArea = {state.activeCamera:getArea()}

	for i, player in ipairs(state.players) do
		player:update(dt)

		if not player:intersects(table.unpack(cameraArea)) then
			player:die()
		end
	end
end

function love.draw()
	state.activeCamera:draw(state.level)

	for i, player in ipairs(state.players) do
		state.activeCamera:draw(player)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.joystickadded()
	for i, player in ipairs(state.players) do
		player:joystickadded()
	end
end
