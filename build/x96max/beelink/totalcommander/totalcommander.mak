TOTCOM_APK := ingredients/TotalCommander.apk
$(call ASSERT.FILE,$(TOTCOM_APK))

HELP = Отличный бесплатный файловый менеджер с управлением от пульта

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/TotalCommander
	cp "$(TOTCOM_APK)" $/system/app/TotalCommander/TotalCommander.apk
	tools/img-perm -f $(DIR)totalcommander.perm -b $/
endef
