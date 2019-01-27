DTVS_APK := ingredients/DroidTvSettings.apk
$(call ASSERT.FILE,$(DTVS_APK))

HELP = Бесплатная навороченная фотогаллерея с открытым исходным текстом

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/vendor/app/DroidTvSettings
	cp "$(DTVS_APK)" $/vendor/app/DroidTvSettings/DroidTvSettings.apk
	tools/img-perm -f $(DIR)droidtvs.perm -b $/
endef
