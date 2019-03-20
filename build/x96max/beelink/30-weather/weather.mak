WEATHER_APK = ingredients/Weather.apk
$(call ASSERT.FILE,$(WEATHER_APK))

HELP = Установка виджета Погода
DEPS += $(DIR)apk-patches/*

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	mkdir -p $/vendor/app/Weather
	cp $(WEATHER_APK) $/vendor/app/Weather/Weather.apk
	$(call APPLY.PATCH.APK,$/vendor/app/Weather/Weather.apk,$(DIR)apk-patches)
	tools/img-perm -f $(DIR)weather.perm -b $/
endef

define DESC
Для использования в составе ATV Launcher и не только имеется виджет
отображения погоды.
endef
