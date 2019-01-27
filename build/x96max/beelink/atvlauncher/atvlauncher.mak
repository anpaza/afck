#$(call MOD.APK,system,atv_launcher.apk,Установка рабочего стола ATV Launcher)
ATVLAUNCH_APK := ingredients/
$(call ASSERT.FILE,$(ATVLAUNCH_APK))

HELP = 

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/ATVLauncher
	cp $(ATVLAUNCH_APK) $/system/app/ATVLauncher/ATVLauncher.apk
	tools/img-perm -f $(DIR)atvlauncher.perm -b $/
endef
