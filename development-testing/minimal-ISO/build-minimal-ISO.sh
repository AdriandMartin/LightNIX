#!/bin/sh
################################################################################
# This script creates a minimal Linux distribution as an ISO file for i386 
# architecture. It just consists of busybox and the Linux kernel
# Author: Adrián Martín
# Thanks: https://github.com/ivandavidov/minimal-linux-script
################################################################################

# Constants definition
KERNEL_VERSION=5.13.5
BUSYBOX_VERSION=1.33.1

#-------------------------------------------------------------------------------
# Get and extract the sources
## Linux kernel
wget -O kernel.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz
tar -xvf kernel.tar.xz
## Busybox
wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
tar -xvf busybox.tar.bz2

#-------------------------------------------------------------------------------
# Create the root filesystem building the userland programs and making the proper directories
mkdir rootfs
## Create the directories which will not be populated by the kernel
cd rootfs
mkdir -p usr/bin
ln -s usr/bin bin
ln -s usr/bin sbin
cd ..
## Build busybox
cd busybox-${BUSYBOX_VERSION}
### Configure busybox (it's required)
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" defconfig
#### Set static compilation's configuration option to "yes"
sed -i "s|.*CONFIG_STATIC.*|CONFIG_STATIC=y|" .config
### Cross-compile busybox for i386 architecture
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" busybox
### Copy the executable into "rootfs/usr/bin"
cp busybox ../rootfs/usr/bin
cd ..
## Create the directories of the root filesystem which will be populated by the kernel
cd rootfs
mkdir dev proc sys
## Create the init script, which initializes the operating system and gives in the control to the shell program
echo '#!/usr/bin/busybox sh' > init
### Mount the kernel's pseudo filesystems
echo '/usr/bin/busybox mount -t devtmpfs none /dev' >> init
echo '/usr/bin/busybox mount -t proc none /proc' >> init
echo '/usr/bin/busybox mount -t sysfs none /sys' >> init
### Create symbolic links to the busybox's commands into "/usr/bin", which will be accesible via "/bin" and "/sbin"
echo '/usr/bin/busybox --install -s /usr/bin' >> init
### Open a shell
echo '/usr/bin/busybox sh' >> init
chmod +x init
## Compress the directory's content as a file named "rootfs.gz"
find . | cpio -R root:root -H newc -o | gzip > ../rootfs.gz
cd ..

#-------------------------------------------------------------------------------
# Cross-compile the kernel for i386 architecture
cd linux-${KERNEL_VERSION}
## Clean the kernel for others architectures
make ARCH=i386 clean
## Copy the template configuration for i386 architecture
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" i386_defconfig
## Build the kernel as an ISO image which include "../rootfs.gz" as the root filesystem
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" FDINITRD=../rootfs.gz isoimage
cd ..

#-------------------------------------------------------------------------------
# Copy the ISO into the main directory and exit successfully
cp linux-${KERNEL_VERSION}/arch/x86/boot/image.iso .
exit 0
