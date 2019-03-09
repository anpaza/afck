$(call MOD.USERAPK,Backgrounds_HD_Wallpapers.apk,Огромная бесплатная коллекция красивых фонов)

DEPS += $(STAMP.mod-init.d)

# Добавим в установку минимальный набор красивых картинок
define INSTALL +=
	cp $(DIR)00-wallpapers $/vendor/etc/init.d/
	mkdir -p $/vendor/Wallpapers
	cp -a ingredients/wallpapers/* $/vendor/Wallpapers
	tools/img-perm -m 0644 -c u:object_r:vendor_app_file:s0 $/vendor/Wallpapers/*
	tools/img-perm -f $(DIR)hdwallpapers.perm -b $/
endef

define DESC
Приложение Backgrounds HD Wallpapers позволит легко выбрать фон или скачать картинки
из онлайн базы данных, содержащей тысячи захватывающих дух фотографий.
endef
