BHDWP_APK := ingredients/Backgrounds_HD_Wallpapers.apk
$(call ASSERT.FILE,$(BHDWP_APK))

HELP = Огромная бесплатная коллекция красивых фонов

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/HDWallpapers
	cp "$(BHDWP_APK)" $/system/app/HDWallpapers/HDWallpapers.apk
	tools/img-perm -f $(DIR)hdwallpapers.perm -b $/
endef
