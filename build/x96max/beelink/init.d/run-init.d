#!/system/bin/sh

test `getprop sys.init.d` != "" && exit 0

set -e

/vendor/xbin/run-parts /system/etc/init.d/

setprop sys.init.d 1
