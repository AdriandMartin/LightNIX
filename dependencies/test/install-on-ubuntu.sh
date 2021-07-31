#!/bin/sh
################################################################################
# This script installs the necessary packages for testing the distribution on 
# Ubuntu
# Author: Adrián Martín
################################################################################

# Checking for root privileges
if [ $( id -u ) -ne 0 ]
then
	echo This script requires root privileges
	exit 1
fi

# Install all the dependencies
apt qemu-system-i386
