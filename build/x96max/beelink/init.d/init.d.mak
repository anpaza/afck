HELP = Добавить автозапуск скриптов из /system/etc/init.d/

$(call IMG.UNPACK.EXT4,vendor)
$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir $/system/etc/init.d
	cp $(DIR)init.d.rc $/vendor/etc/init/
	cp $(DIR)run-init.d $/vendor/xbin/
	tools/img-perm -b $/ -f $(DIR)init.d.perm
endef
