game_name = arctic-grind
game_version = devel

env = GAME_VERSION=$(game_version)

# Building commands
love_file = $(game_name)-$(game_version).love
love: build/$(love_file)

build/$(love_file): $(shell find ./src/ -type f)
	$(env) scripts/package-love.sh $@

# Maintenance commands
check:
	find src -name '*.lua' -not -path 'src/vendor/*' | xargs wc -l | sort -rg
	find src -name '*.lua' -exec luac -p {} + && echo "No problems found"

clean:
	-rm -rf build/

dep:
	scripts/dependency-graph.lua --dot src/main.lua | dot -T png | display

luacheck:
	find src -name '*.lua' -not -path 'src/vendor/*' -exec luacheck {} +

test:
	love src --test

.PHONY: check clean dep love luacheck test
