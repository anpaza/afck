# После выхода из хранителя экрана почему-то иногда перестают работать кнопки "Вниз" и "Ввод".
DISABLED=yes

$(call MOD.USERAPK,org.jwz.android.xscreensaver.apk,Хранитель экрана с сотнями модулей)

# Данный мод применяется только после того, как отработал мод preinstall
DEPS += $(STAMP.mod-preinstall)

define INSTALL +=
	cp $(DIR)40-xscreensaver $/vendor/preinstall/settings
endef

define DESC
Приложение XScreenSaver, известное пользователям Unix, позволит установить анимацию,
запускающуюся при простое приставки.
endef
