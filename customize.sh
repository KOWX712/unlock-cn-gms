if [ -z "$APATCH" ] && [ -z "$KSU" ] && [ "$MAGISK_VER_CODE" -lt 28102 ]; then
    abort "Require Magisk v28102+"
fi

if [ -e /system/etc/permissions/services.cn.google.xml ]; then
    mkdir "$MODPATH/system/etc/permissions"
    mknod "$MODPATH/system/etc/permissions/services.cn.google.xml" c 0 0
elif [ -e /system/etc/permissions/com.oppo.features.cn_google.xml ]; then
    mkdir "$MODPATH/system/etc/permissions"
    mknod "$MODPATH/system/etc/permissions/com.oppo.features.cn_google.xml" c 0 0
elif [ -e /vendor/etc/permissions/services.cn.google.xml ]; then
    mkdir "$MODPATH/system/etc/permissions"
    mknod "$MODPATH/system/vendor/etc/permissions/services.cn.google.xml" c 0 0
elif [ -e /product/etc/permissions/services.cn.google.xml ]; then
    mkdir "$MODPATH/system/etc/permissions"
    mknod "$MODPATH/system/product/etc/permissions/services.cn.google.xml" c 0 0
elif [ -e /product/etc/permissions/cn.google.services.xml ]; then
    mkdir "$MODPATH/system/etc/permissions"
    mknod "$MODPATH/system/product/etc/permissions/cn.google.services.xml" c 0 0
elif [ -e /my_bigball/etc/permissions/oplus_google_cn_gms_features.xml ]; then
    mkdir "$MODPATH/my_bigball/etc/permissions"
    origin="/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml"
elif [ -e /my_heytap/etc/permissions/my_heytap_cn_gms_features.xml ]; then
    mkdir "$MODPATH/my_heytap/etc/permissions"
    origin="/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml"
    if [ -e /my_heytap/etc/permissions/my_heytap_cn_features.xml ]; then
        mkdir "$MODPATH/my_heytap/etc/permissions"
        origin="/my_heytap/etc/permissions/my_heytap_cn_features.xml $origin"
    fi
else
    abort "File not found!"
fi

for file in $origin; do
    cp -f "$file" "$MODPATH/$file"
    sed -i '/cn.google.services/d' "$MODPATH/$file"
    sed -i '/services_updater/d' "$MODPATH/$file"
done

if [ -d "$MODPATH/system" ]; then
    rm -f "$MODPATH/post-fs-data.sh"
else
    touch "$MODPATH/skip_mount"
    touch "$MODPATH/skip_mountify"
fi