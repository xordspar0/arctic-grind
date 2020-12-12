local camera = require("camera")
local player = require("player")
local level = require("level")

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

	state.cameras = {
		camera.new(0, 0, love.graphics.getWidth(), love.graphics.getHeight(),
		           "vpan", state.level.height, 10),
	}

	state.players = {}
	state.players[1] = player.new(200, 10)
end

function love.update(dt)
	for i, player in ipairs(state.players) do
		player:update(dt)
	end

	for i, camera in ipairs(state.cameras) do
		camera:update(dt)
	end
end

function love.draw()
	for i, camera in ipairs(state.cameras) do
		camera:draw(state.level)

		for i, player in ipairs(state.players) do
			camera:draw(player)
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
