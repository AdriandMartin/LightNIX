.PHONY: build clean soft-clean test

build: soft-clean
	cd build/ && ./recipe.sh

clean:
	cd build/ && ./clean.sh

soft-clean:
	cd build/ && ./clean.sh soft

test:
	cd test/ && ./qemu-i386.sh
