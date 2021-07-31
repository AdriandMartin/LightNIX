#!/bin/sh
################################################################################
# This script installs the necessary packages for building the distribution on 
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
apt install wget make gawk gcc-i686-linux-gnu u-boot-tools bc bison flex xorriso libelf-dev libssl-dev
