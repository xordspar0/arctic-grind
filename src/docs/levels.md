# Levels

A level consists of a .zip file or directory that contains the following files:

  * level.lua: This is a Tiled level exported in its Lua format. It should
	contain 2 layers: 'bg' and 'gnd'.
	  * bg is the layer that contains the graphical tiles and objects that make
		up the level's appearance.
	  * gnd is the layer that the player actually interacts with.
		  * 0: air
		  * 1: ground
  * tiles.png (optional): The tileset to use for this level. If you don't
	provide your own, the default for the game will be used instead.
