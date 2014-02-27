############## Start automatic script ####################
#!/bin/sh
export PLATFORM="AOSP"
export MREV="KK4.4"
export CURDATE=`date "+%m.%d.%Y"`
export MUXEDNAMELONG="KT-SGS4-$MREV-$PLATFORM-$CARRIER-$CURDATE"
export MUXEDNAMESHRT="KT-SGS4-$MREV-$PLATFORM-$CARRIER*"
export KTVER="--$MUXEDNAMELONG--"
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export INITRAMFS_DEST=$KERNELDIR/kernel/usr/initramfs
export INITRAMFS_SOURCE=`readlink -f ..`/Ramdisks/$PLATFORM"_"$CARRIER"4.4"
export CONFIG_$PLATFORM_BUILD=y
export PACKAGEDIR=$PARENT_DIR/Packages/$PLATFORM
#Enable FIPS mode
export USE_SEC_FIPS_MODE=true
export ARCH=arm
export CROSS_COMPILE=/home/jeffrey/Kernel/toolchain2/bin/arm-eabi-

#echo "Remove old Package Files"
#rm -rf /home/jeffrey/Kernel/Packages/*

echo "Setup Package Directory"
#mkdir -p /home/jeffrey/Kernel/Packages/system/app
#mkdir -p /home/jeffrey/Kernel/Packages/system/lib/modules
#mkdir -p /home/jeffrey/Kernel/Packages/system/etc/init.d

echo "Remove old zImage"
rm /home/jeffrey/Kernel/Packages/AOSP/zImage
rm arch/arm/boot/zImage

####### echo "Make the kernel"
#make VARIANT_DEFCONFIG=jf_INTL"_defconfig" SELINUX_DEFCONFIG=jfselinux_defconfig SELINUX_LOG_DEFCONFIG=jfselinux_log_defconfig KT_jf_defconfig
#make menuconfig
make -j9


echo "Copy modules/zimage to Package"
cp -a $(find . -name *.ko -print |grep -v initramfs) /home/jeffrey/Kernel/Packages/AOSP/system/lib/modules/

cp arch/arm/boot/zImage /home/jeffrey/Kernel/Packages/AOSP/zImage

####### stop script automatic #######################

#### A faire manuellement : ######################



############   ./mkbootfs /home/jeffrey/Kernel/efficient2.0.0/AOSP/initramfs_src/ | gzip > /home/jeffrey/Kernel/Packages/AOSP/ramdisk.gz
 
########  ./mkbootimg --cmdline 'console = null androidboot.hardware=qcom user_debug=31 zcache androidboot.selinux=permissive' --kernel /home/jeffrey/Kernel/Packages/AOSP/zImage --ramdisk /home/jeffrey/Kernel/Packages/AOSP/ramdisk.gz --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 --output /home/jeffrey/Kernel/Packages/AOSP/boot.img



