local camera = require("camera")
local player = require("player")
local level = require("level")

-- Alias unpack to table.unpack for Lua 5.1 and older.
if not table.unpack then
	table.unpack = unpack
end

state = {}

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	levelName = "default"
	for i, flag in ipairs(arg) do
		if flag == "--level" and arg[i+1] then
			levelName = arg[i+1]
		end
	end

	state.level = level.new(levelName)

	if state.level.music then
		state.level.music:play()
	end

	state.activeCamera = camera.new(
		state.level.spawnPoint[1], state.level.spawnPoint[2],
		love.graphics.getWidth(), love.graphics.getHeight(),
		state.level.height, 10
	)

	state.players = {}
	state.players[1] = player.new(table.unpack(state.level.spawnPoint))
end

function love.update(dt)
	state.activeCamera:update(dt)

	local cameraArea = {state.activeCamera:getArea()}

	for i, player in ipairs(state.players) do
		player:update(dt)

		if not player:intersects(cameraArea[1] - 64, cameraArea[2] - 64, cameraArea[3] + 128, cameraArea[4] + 128) then
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

	if key == "`" then
		state.debug = not state.debug
	end
end

function love.joystickadded()
	for i, player in ipairs(state.players) do
		player:joystickadded()
	end
end
