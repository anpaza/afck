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

define DESC
Добавлена поддержка автозапуска скриптов из подкаталогов init.d. \
Автозапуск происходит в момент окончания загрузки, т.е. когда \
анимированная заставка начинает меняться на рабочий стол.

    * В первую очередь запускаются скрипты из подкаталога /vendor/etc/init.d/
    * Затем запускаются скрипты из /system/etc/init.d/
    * Результаты работы можно найти в файле /data/local/vendor-init.d.log \
и /data/local/system-init.d.log. Очень полезно туда заглянуть, если \
что-то пошло не так.
endef
