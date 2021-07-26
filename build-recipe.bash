#!/bin/sh

# Installing build dependencies
sudo apt install wget make gawk gcc-i686-linux-gnu bc bison flex xorriso libelf-dev libssl-dev

# Constants definition
KERNEL_VERSION=5.13.5
SYSLINUX_VERSION=6.03
BUSYBOX_VERSION=1.33.1

# Getting the sources
wget -O kernel.tar.xz https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz
wget -O syslinux.tar.xz https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.xz
wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2

# Extracting the sources
tar -xvf kernel.tar.xz
tar -xvf syslinux.tar.xz
tar -xvf busybox.tar.bz2

# Create a directory to store the results of compilation
mkdir isoimage

# Build the kernel
cd linux-${KERNEL_VERSION}
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" mrproper defconfig bzImage
# Copy the results into the directory created
cp arch/x86/boot/bzImage ../isoimage/kernel.gz
cd ..

# Build busybox
cd busybox-${BUSYBOX_VERSION}
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" distclean defconfig
sed -i "s|.*CONFIG_STATIC.*|CONFIG_STATIC=y|" .config
make ARCH=i386 CROSS_COMPILE="i686-linux-gnu-" busybox install
# Create the directories of the root filesystem and the init script
cd _install
rm -f linuxrc
mkdir dev proc sys
echo '#!/bin/sh' > init
echo 'dmesg -n 1' >> init
echo 'mount -t devtmpfs none /dev' >> init
echo 'mount -t proc none /proc' >> init
echo 'mount -t sysfs none /sys' >> init
echo 'setsid cttyhack /bin/sh' >> init
chmod +x init
# Copy the results into the directory created
find . | cpio -R root:root -H newc -o | gzip > ../../isoimage/rootfs.gz
cd ../..

# Copy the binaries of the bootloader into the directory created
cp syslinux-${SYSLINUX_VERSION}/bios/core/isolinux.bin isoimage
cp syslinux-${SYSLINUX_VERSION}/bios/com32/elflink/ldlinux/ldlinux.c32 isoimage
echo 'default kernel.gz initrd=rootfs.gz' > isoimage/isolinux.cfg

# Create the ISO file
cd isoimage
xorriso \
  -as mkisofs \
  -o ../lightNIX-i386.iso \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./
cd ..
