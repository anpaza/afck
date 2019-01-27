WEATHER_APK = ingredients/Weather.apk
$(call ASSERT.FILE,$(WEATHER_APK))

HELP = Установка виджета Погода
DEPS += $(DIR)apk-patches/*

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	mkdir -p $/system/app/Weather
	cp $(WEATHER_APK) $/system/app/Weather/Weather.apk
	$(call APPLY.PATCH.APK,$/system/app/Weather/Weather.apk,$(DIR)apk-patches)
	tools/img-perm -f $(DIR)weather.perm -b $/
endef
