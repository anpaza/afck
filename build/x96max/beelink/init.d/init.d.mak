HELP = Добавить автозапуск скриптов из /system/etc/init.d/

$(call IMG.UNPACK.EXT4,vendor)
$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/vendor/etc/init.d
	mkdir -p $/system/etc/init.d
	cp $(DIR)init.d.rc $/vendor/etc/init/
	cp $(DIR)run-init.d $/vendor/bin/
	tools/img-perm -b $/ -f $(DIR)init.d.perm
endef
