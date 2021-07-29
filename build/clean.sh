#!/bin/sh

if [ ${#} -eq 0 ]; then
    rm -rf busybox* linux* syslinux* isoimage/ _rootfs/
elif [ ${#} -eq 1 ] && [ ${1} = "soft" ]; then
    rm -rf isoimage/ _rootfs/
fi
