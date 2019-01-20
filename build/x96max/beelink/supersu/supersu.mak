#
# Установка SuperSU в системном режиме (непосредственно в /system).
#

# Не работает по непонятным причинам.
# Даже при "честной" установке через RECOVERY.
DISABLED = YES

SUPERSU = ingredients/UPDATE-SuperSU-v2.82-*.zip
SUPERSU_ZIP = $(wildcard $(SUPERSU))
$(call ASSERT,$(SUPERSU_ZIP),Мод SuperSU требует наличия файла $(SUPERSU))

HELP = Установка SuperSU

$(call IMG.UNPACK.EXT4,system)

# Команды для установки SuperSU.
# Рецепт взят из файла META-INF/com/google/android/update-binary
define INSTALL
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

	mkdir -p $/system/etc/init.d
	unzip -qoj $(SUPERSU_ZIP) common/99SuperSUDaemon -d $/system/etc/init.d

	touch $/system/etc/.installed_su_daemon

	tools/img-perm -f $(DIR)supersu.perm -b $/
endef
