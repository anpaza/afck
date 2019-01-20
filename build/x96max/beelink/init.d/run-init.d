#!/system/bin/sh

test `getprop sys.init.d` != "" && exit 0

set -e

run-parts /system/etc/init.d/

setprop sys.init.d 1
