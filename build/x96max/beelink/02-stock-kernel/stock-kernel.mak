#
# Замена ядра и модулей в прошивке Билинка на стоковые
#

BOOT_IMG = ingredients/x96max-stock-boot-$(VARIANT).img.lzma
BOOT_TAR = ingredients/x96max-stock-modules.tar.lzma
$(call ASSERT.FILE,$(BOOT_IMG))
$(call ASSERT.FILE,$(BOOT_TAR))

HELP = Замена ядра и драйверов на стоковые

$(call IMG.UNPACK.EXT4,vendor)

# Сами предоставим раздел boot
$(call IMG.WILL.BUILD,boot)

# Правило для копирования ядра
$(IMG.OUT)boot.PARTITION: $(BOOT_IMG) | $(IMG.OUT).stamp.dir
	lzma -d $< -c >$@

define INSTALL
	rm -rf $/vendor/lib/modules/*
	tar xf $(BOOT_TAR) --lzma -C $/vendor/lib/modules/
endef

define DESC
В прошивку установлено стоковое ядро со всеми преимуществами и недостатками:
* Работают часы на передней панели
* Плохое качество воспроизведения черезстрочного видео без libamcodec
endef
