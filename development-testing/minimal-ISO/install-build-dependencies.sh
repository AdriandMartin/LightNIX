#!/bin/sh
################################################################################
# This script installs the dependencies for "build-minimal-ISO.sh" script
# Author: Adrián Martín
# Thanks: https://github.com/ivandavidov/minimal-linux-script
################################################################################

# Checking for root privileges
if [ $( id -u ) -ne 0 ]
then
	echo This script requires root privileges
	exit 1
fi

#-------------------------------------------------------------------------------
# Install all the dependencies
## For downloading the sources
apt install wget
## For cross-compiling the kernel and busybox
apt install make gawk gcc-i686-linux-gnu u-boot-tools bc bison flex libelf-dev libssl-dev
## For generating the ISO (the kernel's "make isoimage" requires it)
apt install syslinux isolinux
## For running the ISO into an i386 emulation
apt install qemu-system-i386
