PG3D_APK := ingredients/PhotoGallery3DHD.apk
$(call ASSERT.FILE,$(PG3D_APK))

HELP = Бесплатная навороченная фотогаллерея с открытым исходным текстом

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/PhotoGallery3DHD
	cp "$(PG3D_APK)" $/system/app/PhotoGallery3DHD/PhotoGallery3DHD.apk
	tools/img-perm -f $(DIR)photogallery3d.perm -b $/
endef
