#!/system/bin/sh

test -n "`getprop init.svc.initd`" && exit 0
setprop init.svc.initd running

run_parts() {
	mkdir -p /data/local
	exec &>/data/local/$1-init.d.log

	for script in /$1/etc/init.d ; do
		if test -x "$script" ; then
			echo "Runnning $script"
			$script
			rc=$?
			if test "$rc" -ne 0 ; then
				echo "$script failed, exit code: $rc"
			fi
		else
			echo "Script $script is not executable, ignoring"
		fi
	done
}

run_parts system

setprop init.svc.initd stopped
