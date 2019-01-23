HELP = Очистка прошивки Beelink от мусора

$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	tools/sed-patch -e '/preinstall Apks/$(COMMA)/^$$/d' \
		-e '/^.HDMI IN/$(COMMA)/^$$/d' \
		$/vendor/etc/init/hw/init.amlogic.board.rc
	rm -f $/system/bin/preinstallApks.sh 
	rm -rf $/system/usr/trigtop
endef
