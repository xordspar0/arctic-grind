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
	self.gnd, self.bg, self.obj, self.fg = {}, {}, {}, {}
	for i, layer in ipairs(levelFile.layers) do
		if layer.type == "tilelayer" and layer.name == "background" then
			self.background = foldTable(layer.data, layer.width)
		elseif layer.type == "tilelayer" and layer.name == "ground" then
			self.ground = foldTable(layer.data, layer.width)
		elseif layer.type == "tilelayer" and layer.name == "objects" then
			self.objects = foldTable(layer.data, layer.width)
		end
	end

	self.width = #self.ground[1] * self.tileSize
	self.height = #self.ground * self.tileSize

	self.tiles = tileset.new(levelName)

	--self.music = resources.loadMusic(levelName)
	--self.music:setLooping(true)

	return self
end

function level:draw()
	-- Draw the background.
	for rowIndex, row in ipairs(self.background) do
		for colIndex, tileNumber in ipairs(row) do
			if tileNumber > 0 then
				love.graphics.draw(
				self.tiles.spritesheet, self.tiles.tile[tileNumber],
				colIndex * self.tileSize, rowIndex * self.tileSize)
			end
		end
	end
	-- Draw the walkable ground.
	for rowIndex, row in ipairs(self.ground) do
		for colIndex, tileNumber in ipairs(row) do
			if tileNumber > 0 then
				love.graphics.draw(
				self.tiles.spritesheet, self.tiles.tile[tileNumber],
				colIndex * self.tileSize, rowIndex * self.tileSize)
			end
		end
	end
end

return level
