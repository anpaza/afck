HELP = Автоматическая установка предустановленных приложений при первой загрузке

# Применяем мод только после мода init.d
DEPS += $(STAMP.mod-init.d)

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	mkdir -p $/vendor/preinstall/settings
	cp -a $(DIR)/00-preinstall $/vendor/etc/init.d
	tools/img-perm -m 0755 -c u:object_r:vendor_configs_file:s0 \
		$/vendor/preinstall/settings \
		$/vendor/etc/init.d/00-preinstall
endef
