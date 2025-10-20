MODPATH="${0%/*}"
mountify_dir="/data/adb/modules/mountify"

[ ! -f "$MODPATH/skip_mount" ] && touch "$MODPATH/skip_mount"

# Let mountify handle mount
if [ -d "$mountify_dir" ] && [ ! -f "$mountify_dir/disable" ] && [ ! -f "$mountify_dir/remove" ]; then
    exit 0
fi

# mountify standalone
if [ -f "$MODPATH/mountify.sh" ]; then
    sh "$MODPATH/mountify.sh"
    exit 0
fi

# Fallback to official method
for dir in $MODPATH/*/; do
    find "$dir" -type f | while read file; do
        origin=${file#$MODPATH}
        echo "unlock-cn-gms: post-fs-data.sh - mounting $file to $origin" >> /dev/kmsg
        mount -o ro,bind "$file" "$origin"
    done
done
