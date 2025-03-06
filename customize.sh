#!/bin/sh

# Function to find the first available XML permission file
find_origin() {
    files="
    /system/etc/permissions/services.cn.google.xml
    /system/etc/permissions/com.oppo.features.cn_google.xml
    /vendor/etc/permissions/services.cn.google.xml
    /product/etc/permissions/services.cn.google.xml
    /product/etc/permissions/cn.google.services.xml
    /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
    /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml
    "
    for file in $files; do
        if [ -e "$file" ]; then
            echo "$file"
            return
        fi
    done
    abort "No suitable permission file found!"
}

handle_target() {
    target=$1
    origin=$2
    mkdir -p $(dirname $target)
    if [ "$SUPPORT_REMOVE" = 1 ] || [ "$MEETS_MOUNTIFY" = 1 ]; then
        mknod $target c 0 0
    else
        cp -f $origin $target
        sed -i '/cn.google.services/d' $target
        sed -i '/services_updater/d' $target
    fi
}

mountify_check() {
    if grep -q "overlay" /proc/filesystems > /dev/null 2>&1; then
        MEETS_OVERLAYFS=1
    fi
    [ -w /mnt ] && MNT_FOLDER=/mnt
    [ -w /mnt/vendor ] && MNT_FOLDER=/mnt/vendor
    testfile="$MNT_FOLDER/tmpfs_xattr_testfile"
    rm $testfile > /dev/null 2>&1 
    mknod "$testfile" c 0 0 > /dev/null 2>&1 
    if setfattr -n trusted.overlay.whiteout -v y "$testfile" > /dev/null 2>&1 ; then 
        MEETS_TMPFS_XATTR=1
        rm $testfile > /dev/null 2>&1
    fi
    if [ "$MEETS_OVERLAYFS" = 1 ] && [ "$MEETS_TMPFS_XATTR" = 1 ]; then
        MEETS_MOUNTIFY=1
    fi
}

# Check eligible whiteout support
if [ -z "$APATCH" ] && [ -z "$KSU" ] && [ "$MAGISK_VER_CODE" -lt 28102 ]; then
    SUPPORT_REMOVE=0
else
    SUPPORT_REMOVE=1
fi

# Check eligible for mountify support
mountify_check
if [ "$MEETS_MOUNTIFY" = 1 ]; then
    mv -f $MODPATH/mountify.sh $MODPATH/post-fs-data.sh
else
    rm -f $MODPATH/mountify.sh
fi

origin=$(find_origin)

if [ $origin = *my_bigball* ]; then
    SUPPORT_REMOVE=0
    handle_target $MODPATH/oplus_google_cn_gms_features.xml $origin
elif [ $origin = *my_heytap* ]; then
    SUPPORT_REMOVE=0
    handle_target $MODPATH/my_heytap_cn_gms_features.xml $origin
    if [ -e /my_heytap/etc/permissions/my_heytap_cn_features.xml ]; then
        handle_target $MODPATH/my_heytap_cn_features.xml /my_heytap/etc/permissions/my_heytap_cn_features.xml
    fi
elif [ $origin = *system* ]; then
    handle_target $MODPATH$origin $origin
else
    handle_target $MODPATH/system$origin $origin
fi

[ "$SUPPORT_REMOVE" = 1 ] && rm -f $MODPATH/post-fs-data.sh
