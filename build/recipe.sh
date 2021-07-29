#!/bin/sh

# Constants definition
## Source common definitions
. ../common.sh
## Paths
BUILD_PATH=$(pwd)
RELEASES_PATH=${BUILD_PATH}/../releases
ROOTFS_DIR=rootfs
ISOIMAGE_PATH=${BUILD_PATH}/isoimage
## Software
KERNEL_VERSION=5.13.5
KERNEL_SOURCES="linux-${KERNEL_VERSION}"
SYSLINUX_VERSION=6.03
SYSLINUX_SOURCES="syslinux-${SYSLINUX_VERSION}"
BUSYBOX_VERSION=1.33.1
BUSYBOX_SOURCES="busybox-${BUSYBOX_VERSION}"

#-------------------------------------------------------------------------------
# Create a directory to store the build results
mkdir ${ISOIMAGE_PATH}

#-------------------------------------------------------------------------------
# Kernel
## Check if the kernel tarball exists, and if it doesn't, download it
if [ ! -f ${KERNEL_SOURCES}.tar.xz ]; then
    wget -O ${KERNEL_SOURCES}.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/${KERNEL_SOURCES}.tar.xz
fi
## Check if the kernel's source directory exists, and if it doesn't, extract it from the tarball
if [ ! -d ${KERNEL_SOURCES}/ ]; then
    tar -xvf ${KERNEL_SOURCES}.tar.xz
fi
## Check if the kernel is compiled yet, and if it doesn't, configure and build it
if [ ! -f ${KERNEL_SOURCES}/arch/x86/boot/bzImage ]; then
    cd ${KERNEL_SOURCES}
    ## Apply the patches required
    # ;
    ## Clean the kernel for others architectures
    make ARCH=i386 clean
    ## Copy the template configuration for i386 architecture
    make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" i386_defconfig
    ## Edit the required configuration options
    ### Define the operating system's name as "LightNIX"
    sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"LightNIX\"/" .config
    ## Build the kernel as a compressed image
    make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" bzImage
    ## Return
    cd ${OLDPWD}
fi
## Copy the kernel's compressed file into the results directory
cp ${KERNEL_SOURCES}/arch/x86/boot/bzImage ${ISOIMAGE_PATH}/kernel.gz

#-------------------------------------------------------------------------------
# Bootloader
## Check if the bootloader tarball exists, and if it doesn't, download it
if [ ! -f ${SYSLINUX_SOURCES}.tar.xz ]; then
    wget -O ${SYSLINUX_SOURCES}.tar.xz https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/${SYSLINUX_SOURCES}.tar.xz
fi
## Check if the bootloader's source directory exists, and if it doesn't, extract it from the tarball
if [ ! -d ${SYSLINUX_SOURCES}/ ]; then
    tar -xvf ${SYSLINUX_SOURCES}.tar.xz
fi
## Copy the binaries of the bootloader into the results directory
cp ${SYSLINUX_SOURCES}/bios/core/isolinux.bin ${ISOIMAGE_PATH}/
cp ${SYSLINUX_SOURCES}/bios/com32/elflink/ldlinux/ldlinux.c32 ${ISOIMAGE_PATH}/
## Create a bootloading configuration file
echo 'default kernel.gz initrd=rootfs.gz' > ${ISOIMAGE_PATH}/isolinux.cfg

#-------------------------------------------------------------------------------
# Create a basic root filesystem from the template
## Create a copy of "rootfs" named "_rootfs"
cp -r ${ROOTFS_DIR}/ _${ROOTFS_DIR}/
## Edit the existing template files in the copy
sed -i "s/ARCH/${LIGHTNIX_RELEASE_ARCH}/" _${ROOTFS_DIR}/init
sed -i "s/VERSION/${LIGHTNIX_RELEASE_VERSION}/" _${ROOTFS_DIR}/init
## Create the empty directories which are necessaries
cd _${ROOTFS_DIR}/
mkdir dev proc sys
## Create the directories in which the binaries will be placed
mkdir -p usr/bin
ln -s usr/bin bin
ln -s usr/bin sbin
## Return
cd ${OLDPWD}

#-------------------------------------------------------------------------------
# User programs
## Check if the busybox tarball exists, and if it doesn't, download it
if [ ! -f ${BUSYBOX_SOURCES}.tar.xz ]; then
    wget -O ${BUSYBOX_SOURCES}.tar.bz2 https://busybox.net/downloads/${BUSYBOX_SOURCES}.tar.bz2
fi
## Check if busybox's source directory exists, and if it doesn't, extract it from the tarball
if [ ! -d ${BUSYBOX_SOURCES}/ ]; then
    tar -xvf ${BUSYBOX_SOURCES}.tar.bz2
fi
## Check if busybox is compiled yet, and if it doesn't, configure and build it
if [ ! -f ${BUSYBOX_SOURCES}/busybox ]; then
    cd busybox-${BUSYBOX_VERSION}
    ### Clean the project
    make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" distclean
    ### Configure busybox
    make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" defconfig
    ### Set static compilation's configuration option to "yes"
    sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config
    ### Build busybox
    make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" busybox
    ### Return
    cd ${OLDPWD}
fi
## Copy the resulting binary in the root directory
cp ${BUSYBOX_SOURCES}/busybox _${ROOTFS_DIR}/usr/bin
## Copy the configuration files in the root directory
# ;

#-------------------------------------------------------------------------------
# Root filesystem
cd _${ROOTFS_DIR}
## Create a compressed file in the results directory with the content of the root directory
find . | cpio -R root:root -H newc -o | gzip > ${ISOIMAGE_PATH}/rootfs.gz
## Return
cd ${OLDPWD}

#-------------------------------------------------------------------------------
# Create the ISO file
cd ${ISOIMAGE_PATH}
xorriso \
  -as mkisofs \
  -o ${RELEASES_PATH}/lightNIX-${LIGHTNIX_RELEASE_ARCH}-${LIGHTNIX_RELEASE_VERSION}.iso \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./
## Return
cd ${OLDPWD}

#-------------------------------------------------------------------------------
# Exit
exit 0
