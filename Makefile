.PHONY: all build clean

BINARY_NAME=trd.tic

all: build

build: trd.tic

trd.lua: main.lua assets.lua events.lua mc_lib.lua m3_lib.lua grid.lua enum.lua
	lua ../tic80-lua-packer/packer.lua --title="Tile Reactor Defense" --main=main.lua --assets=assets.lua events.lua mc_lib.lua m3_lib.lua grid.lua enum.lua --output=trd.lua

trd.tic: trd.lua
	tic80 --cli --fs=./ --cmd="load trd.lua" --cmd="save trd.tic"

clean:
	rm trd.lua trd.tic
