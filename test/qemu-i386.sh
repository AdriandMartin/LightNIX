#!/bin/sh
################################################################################
# This script boots the ISO file on a QEMU virtual machine
# Author: Adrián Martín
################################################################################

# Import common definitions
. ../common.sh

# Import definition of tests' common parameters
. ./common.sh

# Test the distribution on a virtual machine with the given configuration
qemu-system-i386 -m ${RAM_SIZE} \
                 -k ${KEYBOARD_DISTRIBUTION} \
                 -smp cpus=${NUMBER_OF_CORES} \
                 -cdrom ../releases/lightNIX-${LIGHTNIX_RELEASE_ARCH}-${LIGHTNIX_RELEASE_VERSION}.iso \
                 -boot d \
                 -vga std
