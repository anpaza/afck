#
# Замена ядра и модулей в прошивке Билинка на стоковые
#

BOOT_IMG = ingredients/x96max-stock-boot-$(VARIANT).img
BOOT_ZIP = ingredients/x96max-stock-modules.zip
$(call ASSERT,$(wildcard $(BOOT_IMG)),Файл $(BOOT_IMG) не найден!)
$(call ASSERT,$(wildcard $(BOOT_ZIP)),Файл $(BOOT_ZIP) не найден!)

HELP = Заменить ядро и модули на стоковые

$(call IMG.UNPACK.EXT4,vendor)

# Сами предоставим раздел boot
$(call IMG.WILL.BUILD,boot)

# Правило для копирования ядра
$(IMG.OUT)boot.PARTITION: $(BOOT.IMG)
	$(call CP,$<,$@)

define INSTALL
	rm -rf $/vendor/lib/modules/*
	unzip $(BOOT_ZIP) -d $/vendor/lib/modules/
endef
