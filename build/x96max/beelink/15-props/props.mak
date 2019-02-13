BOOTANIM = ingredients/bootanimation.zip
$(call ASSERT.FILE,$(BOOTANIM))

HELP = Тюнинг свойств ОС

define DESC
* Установлена временная зона Москва/Россия
* Разрешено использование 13 каналов WiFi 2.4ГГц
* Чувствительность на движения мыши чуть увеличена
* Заменена загрузочная анимация
endef

$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	tools/setprop -f $/vendor/build.prop \
		ro.vendor.product.model=X96MAX \
		ro.vendor.product.manufacturer=Vontar \
		ro.product.device=$(PRODEV) \
		ro.com.android.dateformat=dd-MM-yyyy \
		ro.vendor.sw.version="$(FIRMNAME) $(VER)"
	tools/setprop -f $/system/build.prop \
		ro.product.model=X96MAX \
		ro.product.locale=ru-RU \
		ro.product.manufacturer=Amlogic \
		ro.build.date="$(shell date +%c)" \
		ro.build.date.utc="$(shell date +%s)" \
		ro.build.user="$(shell whoami)" \
		ro.build.host="$(shell hostname)" \
		persist.sys.timezone=Europe/Moscow \
		persist.sys.country=RU \
		persist.sys.language=ru \
		ro.wifi.channels=13 \
		net.bt.name=x96max \
		ro.fota.platform= \
		ro.fota.type= \
		ro.fota.app= \
		ro.fota.id= \
		ro.fota.oem= \
		ro.fota.device= \
		ro.fota.version= \
		ro.expect.recovery_id=
	cp $(BOOTANIM) $/system/media/bootanimation.zip
	tools/img-perm -m 0644 -c u:object_r:system_file:s0 \
		$/system/media/bootanimation.zip
	cp $(DIR)15-pointer-speed $/vendor/preinstall/settings
	tools/img-perm -m 0644 -c u:object_r:vendor_file:s0 \
		$/vendor/preinstall/settings/15-pointer-speed
endef
