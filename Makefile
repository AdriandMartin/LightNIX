.PHONY: build clean soft-clean test

#----------------------------------------------------
# Build rules

build: soft-clean
	cd build/ && ./recipe.sh

#----------------------------------------------------
# Clean rules

clean:
	cd build/ && ./clean.sh

soft-clean:
	cd build/ && ./clean.sh soft

#----------------------------------------------------
# Test rules

test:
	cd test/ && ./qemu-i386.sh
