#
# Установка SuperSU в системном режиме (непосредственно в /system).
#

HELP = Исправление клавиши Enter в файле описания клавиатуры

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	$(call APPLY.PATCH,$(DIR)generic.diff,$(IMG.OUT),-p0)
endef
