#!/bin/sh
################################################################################
# This script removes the indicated files and directories which are result of 
# the distribution build process
# Author: Adrián Martín
################################################################################

if [ ${#} -eq 0 ]; then
    # If no argument is given, all the files and directories generated are removed
    rm -rf busybox* linux* syslinux* isoimage/ _rootfs/
elif [ ${#} -eq 1 ] && [ ${1} = "soft" ]; then
    # If an argument with value "soft" is given, just the directories "isoimage/" and "_rootfs/" are removed
    rm -rf isoimage/ _rootfs/
fi
