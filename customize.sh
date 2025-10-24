#!/bin/sh

# Function to find the first available XML permission file
OLD_MODPATH="/data/adb/modules/com.fei_ke.unlockcngms"
FILES="/system/etc/permissions/services.cn.google.xml
/system/etc/permissions/com.oppo.features.cn_google.xml
/vendor/etc/permissions/services.cn.google.xml
/product/etc/permissions/services.cn.google.xml
/product/etc/permissions/cn.google.services.xml
/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
/my_product/etc/permissions/oplus_google_cn_gms_features.xml
/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml"

find_origin() {
    for file in $FILES; do
        if [ -e "$file" ] || [ -e "$OLD_MODPATH$file" ] || [ -e "$OLD_MODPATH/system$file" ]; then
            echo "$file"
        fi
    done
    abort "No suitable permission file found!"
}

handle_target() {
    target=$1
    origin=$2
    DIR_OF_TARGET="$(dirname $target)"
    mkdir -p "$DIR_OF_TARGET"
    if [ "$SUPPORT_REMOVE" = 1 ] || [ "$MEETS_MOUNTIFY_STANDALONE" = 1 ] || [ "$HAS_MOUNTIFY" = 1 ]; then
        mknod "$target" c 0 0
        setfattr -n trusted.overlay.opaque -v y "$target"
    else
        cp -f "$origin" "$target"
        sed -i '/cn.google.services/d' "$target"
        sed -i '/services_updater/d' "$target"
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
        MEETS_MOUNTIFY_STANDALONE=1
    else
        MEETS_MOUNTIFY_STANDALONE=0
    fi

    mountify_dir="/data/adb/modules/mountify"
    if [ -d "$mountify_dir" ] && [ ! -f "$mountify_dir/disable" ] && [ ! -f "$mountify_dir/remove" ]; then
        HAS_MOUNTIFY=1
    else
        HAS_MOUNTIFY=0
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
if [ ! "$MEETS_MOUNTIFY_STANDALONE" = 1 ]; then
    rm -f "$MODPATH/mountify.sh"
fi

origin=$(find_origin)

if [ $origin = *my_bigball* ] || [ $origin = *my_product* ]; then
    SUPPORT_REMOVE=0
    handle_target "$MODPATH$origin" "$origin"
elif [ $origin = *my_heytap* ]; then
    SUPPORT_REMOVE=0
    handle_target "$MODPATH$origin" "$origin"
    if [ -e "/my_heytap/etc/permissions/my_heytap_cn_features.xml" ]; then
        handle_target "$MODPATH/my_heytap/etc/permissions/my_heytap_cn_features.xml" "/my_heytap/etc/permissions/my_heytap_cn_features.xml"
    fi
elif [ $origin = *system* ]; then
    handle_target "$MODPATH$origin" "$origin"
else
    handle_target "$MODPATH/system$origin" "$origin"
fi

[ "$SUPPORT_REMOVE" = 1 ] && rm -f "$MODPATH/post-fs-data.sh" "$MODPATH/mountify.sh"
