.PHONY: all build clean test

BINARY_NAME=trd.tic

all: build

build: trd.tic

trd.tic: trd.lua
	tic80 --cli --fs=./ --cmd="load trd.lua" --cmd="save trd.tic"

clean:
	rm trd.lua trd.tic

test:
	lua tests.lua
