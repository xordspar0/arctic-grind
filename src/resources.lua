local resources = {}

local characterDir = "res/char/"
local levelDir = "res/levels/"

function resources.loadCharacter(characterName)
	character = love.filesystem.load(characterDir .. characterName .. "/char.lua")
	return character()
end

function resources.loadSprite(characterName, spriteName)
	return love.graphics.newImage(characterDir .. characterName .. "/" .. spriteName)
end

function resources.loadLevel(levelName)
	level = love.filesystem.load(levelDir .. levelName .. "/level.lua")

	return level()
end

function resources.loadTileset(levelName)
	return love.graphics.newImage(levelDir .. "tiles.png")
end

function resources.loadMusic(levelName)
	return love.audio.newSource(levelDir .. levelName .. '/music.ogg')
end

return resources
