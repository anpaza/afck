#
# Исправленный U-Boot, не реагирующий на включение по кнопкам
# от пульта телевизоров LG.
#

BOOTLOADER_IMG = ingredients/x96max-bootloader.img.lzma
$(call ASSERT.FILE,$(BOOTLOADER_IMG))
DTB_IMG = ingredients/x96max-dtb.img.lzma
$(call ASSERT.FILE,$(DTB_IMG))

HELP = Исправление ложной реакции на пульты от телевизоров LG

# Сами предоставим раздел boot
### УВАГА в текущей версии U-Boot починен пульт, но сломана поддержка Amlogic Burning Tool.
#$(call IMG.WILL.BUILD,DDR)
$(call IMG.WILL.BUILD,_aml_dtb)

# Правило для копирования ядра
#$(IMG.OUT)DDR.USB: $(BOOTLOADER_IMG) | $(IMG.OUT).stamp.dir
#	lzma -d $< -c >$@

$(IMG.OUT)_aml_dtb.PARTITION: $(DTB_IMG) | $(IMG.OUT).stamp.dir
	lzma -d $< -c >$@

define INSTALL
	#
endef

define DESC
В состав прошивки входит модифицированный начальный загрузчик U-Boot,
в котором исправлено ложное включение приставки по нажатию кнопок
с пульта телевизоров LG.
endef
