usage:
	@echo "make icon"
	@echo "make dmg"
	@echo "make clean"

icon:
	@bash icon.sh

dmg: icon
	@bash dmg.sh

clean:
	@rm -rf ./appicon.iconset
	@rm -rf ./appicon.icns

	@rm -rf ./node_modules
	@rm -rf Ubx.dmg
	@rm -rf Ubx.app

