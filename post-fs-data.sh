MODPATH="${0%/*}"

[ ! -f $MODDIR/skip_mount ] && touch $MODDIR/skip_mount
[ ! -f $MODDIR/skip_mountify ] && touch $MODDIR/skip_mountify

for dir in $MODPATH/*/; do
    find "$dir" -type f | while read file; do
        origin=${file#$MODPATH}
        echo "unlock-cn-gms: post-fs-data.sh - mounting $file to $origin" >> /dev/kmsg
        mount -o ro,bind "$file" "$origin"
    done
done
