MODPATH="${0%/*}"

for dir in $MODPATH/*/; do
    find "$dir" -type f | while read file; do
        origin=${file#$MODPATH}
        echo "unlock-cn-gms: post-fs-data.sh - mounting $file to $origin" >> /dev/kmsg
        mount -o ro,bind "$file" "$origin"
    done
done
