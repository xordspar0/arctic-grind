game_name = arctic-grind
game_version = devel
release_mode = debug

env = GAME_VERSION=$(game_version) ANDROID_SDK_ROOT=$${HOME}/Android/Sdk

# Building commands
apk_file = build/$(game_name)-$(game_version).apk
app: $(apk_file)

love_file = build/$(game_name)-$(game_version).love
love: $(love_file)

$(apk_file): $(love_file)
	sed -i /android.permission.BLUETOOTH/d love-android/app/src/main/AndroidManifest.xml
	cd love-android && $(env) ./gradlew assembleEmbed
	cp love-android/app/build/outputs/apk/embed/$(release_mode)/app-embed-$(release_mode).apk $(apk_file)

$(love_file): $(shell find ./src/ -type f)
	$(env) scripts/package-love.sh $@

# Debugging commands

install: $(apk_file)
	adb install -r $(apk_file)

launch: install
	adb shell am start -n "org.love2d.android.embed/org.love2d.android.GameActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

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

.PHONY: check clean dep install launch love luacheck test
