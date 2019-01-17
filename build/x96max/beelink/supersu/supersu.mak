#
# Установка SuperSU в системном режиме (непосредственно в /system).
#

SUPERSU = ingredients/UPDATE-SuperSU-v2.82-*.zip
SUPERSU_ZIP = $(wildcard $(SUPERSU))
$(call ASSERT,$(SUPERSU_ZIP),Мод SuperSU требует наличия файла $(SUPERSU))

HELP = Установка SuperSU

$(call IMG.UNPACK.EXT4,system)

# Команды для установки SuperSU.
# Рецепт взят из файла META-INF/com/google/android/update-binary
define INSTALL
	echo -e "SYSTEMLESS=true\nPATCHBOOTIMAGE=false" >$/system/.supersu
	mkdir -p $/system/app/SuperSU
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/app/SuperSU

	unzip -qoj $(SUPERSU_ZIP) common/Superuser.apk -d $/system/app/SuperSU
	mv -f $/system/app/SuperSU/Superuser.apk $/system/app/SuperSU/SuperSU.apk
	tools/img-perm 0644 u:object_r:system_file:s0 $/system/app/SuperSU/SuperSU.apk

	unzip -qoj $(SUPERSU_ZIP) common/install-recovery.sh -d $/system/etc
	tools/img-perm 0755 u:object_r:toolbox_exec:s0 $/system/etc/install-recovery.sh
	ln -fs /system/etc/install-recovery.sh $/system/bin/install-recovery.sh

	unzip -qoj $(SUPERSU_ZIP) armv7/su -d $/system/xbin
	tools/img-perm 0755 u:object_r:su_exec:s0 $/system/xbin/su

	mkdir -p $/system/bin/.ext
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/bin/.ext
	cp -a $/system/xbin/su $/system/bin/.ext/su
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/bin/.ext/su

	cp -a $/system/xbin/su $/system/xbin/daemonsu
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/xbin/daemonsu

	unzip -qoj $(SUPERSU_ZIP) armv7/supolicy -d $/system/xbin
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/xbin/supolicy

	unzip -qoj $(SUPERSU_ZIP) armv7/libsupol.so -d $/system/lib
	tools/img-perm 0644 u:object_r:system_file:s0 $/system/lib/libsupol.so

	test -L $/system/bin/app_process32 || \
	cp -a $/system/bin/app_process32 $/system/bin/app_process32_original
	tools/img-perm 0755 u:object_r:zygote_exec:s0 $/system/bin/app_process32_original
	test -L $/system/bin/app_process32 || \
	cp -a $/system/bin/app_process32 $/system/bin/app_process_init
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/bin/app_process_init
	ln -fs /system/xbin/daemonsu $/system/bin/app_process
	ln -fs /system/xbin/daemonsu $/system/bin/app_process32

	unzip -qoj $(SUPERSU_ZIP) common/99SuperSUDaemon -d $/system/etc/init.d
	tools/img-perm 0755 u:object_r:system_file:s0 $/system/etc/init.d/99SuperSUDaemon

	touch $/system/etc/.installed_su_daemon
	tools/img-perm 0644 u:object_r:system_file:s0 $/system/etc/.installed_su_daemon
endef
