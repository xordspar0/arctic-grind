local resources = require("resources")
local tileset = require("tileset")

local level = {}

level.tileSize = 32

local function foldTable(longTable, width)
	foldedTable = {}

	row = 1
	col = 1
	foldedTable[row] = {}
	for i, value in ipairs(longTable) do
		foldedTable[row][col] = value

		col = col + 1
		if col > width then
			row = row + 1
			col = 1
			foldedTable[row] = {}
		end
	end

	return foldedTable
end

function level.new(levelName)
	local self = {}
	setmetatable(self, {__index = level})

	self.name = levelName

	local levelFile = resources.loadLevel(levelName)
	for i, layer in ipairs(levelFile.layers) do
		if layer.type == "tilelayer" and layer.name == "background" then
			self.background = foldTable(layer.data, layer.width)
		elseif layer.type == "tilelayer" and layer.name == "ground" then
			self.ground = foldTable(layer.data, layer.width)
		elseif layer.type == "objectgroup" and layer.name == "objects" then
			self.objects = layer.objects
		end
	end

	self.width = #self.ground[1] * self.tileSize
	self.height = #self.ground * self.tileSize

	for i, object in ipairs(self.objects) do
		if object.name == "spawn" then
			self.spawnPoint = {object.x, object.y}
			break
		end
	end

	self.tiles = tileset.new(levelName)

	--self.music = resources.loadMusic(levelName)
	--self.music:setLooping(true)

	return self
end

function level:draw()
	-- Draw the background.
	for y = 0, #self.background - 1 do
		for x = 0, #self.background[y+1] - 1 do
			local tileType = self.background[y+1][x+1]
			if tileType > 0 then
				love.graphics.draw(
				self.tiles.spritesheet, self.tiles.tile[tileType],
				x * self.tileSize, y * self.tileSize)
			end
		end
	end
	-- Draw the walkable ground.
	for y = 0, #self.ground - 1 do
		for x = 0, #self.ground[y+1] - 1  do
			local tileType = self.ground[y+1][x+1]
			if tileType > 0 then
				love.graphics.draw(
				self.tiles.spritesheet, self.tiles.tile[tileType],
				x * self.tileSize, y * self.tileSize)
			end
		end
	end
end

function level:collides(x, y)
	local column = math.floor(x / self.tileSize) + 1
	local row = math.floor(y / self.tileSize) + 1

	-- If outside the level, then there is no collision.
	if not self.ground[row] or not self.ground[row][col] then
		return false
	end

	return self.ground[row][column] > 0
end

return level
