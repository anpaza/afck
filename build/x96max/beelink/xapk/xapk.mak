XAPK_APK := ingredients/XAPK_Installer.apk
$(call ASSERT.FILE,$(XAPK_APK))

HELP = Установщик APK и XAPK файлов

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/XAPKInstaller
	cp "$(XAPK_APK)" $/system/app/XAPKInstaller/XAPKInstaller.apk
	tools/img-perm -f $(DIR)xapk.perm -b $/
endef
