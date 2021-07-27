#!/bin/sh
################################################################################
# This script executes the distribution created by "build-minimal-ISO.sh" as an 
# qemu's i386 emulation
# Author: Adrián Martín
# Thanks: https://github.com/ivandavidov/minimal-linux-script
################################################################################

# Boot the ISO file in an i386 machine with 64MB of RAM
qemu-system-i386 -m 64M -cdrom image.iso -boot d -vga std
