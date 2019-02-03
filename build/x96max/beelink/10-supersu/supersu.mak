#
# Установка SuperSU в системном режиме (непосредственно в /system).
#

SUPERSU_ZIP = ingredients/UPDATE-SuperSU-v2.82-20170528234214.zip
$(call ASSERT.FILE,$(SUPERSU_ZIP))

HELP = Установка SuperSU
DEPS += $(STAMP.mod-init.d) $(DIR)apk-patches/*

$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

# Команды для установки SuperSU.
#
# В прошивке Beelink уже присутствует демон supersu и команда su.
# Нам нужно лишь обновить их до последней версии и хакнуть слегонца
# SuperSU.apk так, чтобы он не проверял "правильность установки", иначе
# он предлагает "обновить su" и это заканчивается зависанием при загрузке.
define INSTALL
	mkdir -p $/system/app/SuperSU
	unzip -qojp $(SUPERSU_ZIP) common/Superuser.apk > $/system/app/SuperSU/SuperSU.apk
	# Пропатчим SuperSU
	$(call APPLY.PATCH.APK,$/system/app/SuperSU/SuperSU.apk,$(DIR)apk-patches)
	unzip -qoj $(SUPERSU_ZIP) armv7/su -d $/system/xbin
	rm -f $/system/bin/su
	cp $(DIR)99SuperSUDaemon $/system/etc/init.d
	# Уберём следы "автозапуска" daemonsu от amlogic
	tools/sed-patch -e '/add root inferface/$(COMMA)/^persist.daemonsu.enable/d' \
		$/system/build.prop
	tools/sed-patch -e '/root permission/$(COMMA)/start daemonsu/d' \
		$/vendor/etc/init/hw/init.amlogic.board.rc
	tools/img-link -f su $/system/xbin/daemonsu
	tools/img-perm -f $(DIR)supersu.perm -b $/
endef

# Рецепт взят из файла META-INF/com/google/android/update-binary
# для установки SuperSU в SYSTEM режиме (новые версии предпочитают
# режим SYSTEM-less, когда модифицируется boot.img и сам su устанавливается
# в образ ext4 /data/su.img, который монтируется на /su).
#
# Данный рецепт НЕ ИСПОЛЬЗУЕТСЯ т.к. не работает на x96max.
define INSTALL___SYSTEM
	echo -e "SYSTEMLESS=false\nPATCHBOOTIMAGE=false" >$/system/.supersu

	mkdir -p $/system/app/SuperSU
	unzip -qoj $(SUPERSU_ZIP) common/Superuser.apk -d $/system/app/SuperSU
	mv -f $/system/app/SuperSU/Superuser.apk $/system/app/SuperSU/SuperSU.apk

	unzip -qoj $(SUPERSU_ZIP) common/install-recovery.sh -d $/system/etc
	ln -fs /system/etc/install-recovery.sh $/system/bin/install-recovery.sh

	unzip -qoj $(SUPERSU_ZIP) armv7/su -d $/system/xbin

	mkdir -p $/system/bin/.ext
	cp -a $/system/xbin/su $/system/bin/.ext/.su

	cp -a $/system/xbin/su $/system/xbin/daemonsu

	unzip -qoj $(SUPERSU_ZIP) armv7/supolicy -d $/system/xbin

	unzip -qoj $(SUPERSU_ZIP) armv7/libsupol.so -d $/system/lib

	test -L $/system/bin/app_process32 || \
	cp -a $/system/bin/app_process32 $/system/bin/app_process32_original
	test -L $/system/bin/app_process32 || \
	cp -a $/system/bin/app_process32 $/system/bin/app_process_init
	ln -fs /system/xbin/daemonsu $/system/bin/app_process
	ln -fs /system/xbin/daemonsu $/system/bin/app_process32

	unzip -qoj $(SUPERSU_ZIP) common/99SuperSUDaemon -d $/system/etc/init.d

	touch $/system/etc/.installed_su_daemon

	tools/img-perm -f $(DIR)supersu-system.perm -b $/
endef
