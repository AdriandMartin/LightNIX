#!/bin/sh
################################################################################
# This script cleans the files created by "build-minimal-ISO.sh"
# Author: Adrián Martín
# Thanks: https://github.com/ivandavidov/minimal-linux-script
################################################################################

# Remove the directories
rm -r busybox*/ linux*/ rootfs/

# Remove the files
rm kernel.tar.xz busybox.tar.bz2 rootfs.gz image.iso
