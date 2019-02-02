#!/system/bin/sh

test -n "`getprop init.svc.initd`" && exit 0
setprop init.svc.initd running

run-parts /system/etc/init.d/

setprop init.svc.initd stopped
