.PHONY: all build

BINARY_NAME=trd.tic

all: build

build: trd.lua

trd.lua: main.lua assets.lua events.lua mc_lib.lua m3_lib.lua grid.lua enum.lua
	lua ../tic80-lua-packer/packer.lua --title="Tile Reactor Defense" --main=main.lua --assets=assets.lua events.lua mc_lib.lua m3_lib.lua grid.lua enum.lua --output=trd.lua
