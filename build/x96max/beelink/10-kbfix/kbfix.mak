# Отключено т.к. поганит работу пульта с виртуальной клавой
DISABLED = yes

HELP = Исправление клавиши Enter в файле описания клавиатуры

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	$(call APPLY.PATCH,$(DIR)generic.diff,$(IMG.OUT),-p0)
endef
