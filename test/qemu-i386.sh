#!/bin/sh

# Source common definitions
. ../common.sh

# Test the distribution in a virtual machine
qemu-system-i386 -m 128M \
                 -cdrom ../releases/lightNIX-${LIGHTNIX_RELEASE_ARCH}-${LIGHTNIX_RELEASE_VERSION}.iso \
                 -boot d \
                 -vga std
