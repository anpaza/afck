#---------------------------------
# Установка libamcodec в прошивку
#---------------------------------

# Описание мода
HELP = Установка libamcodec.so

# Для модификации нам нужны распакованные разделы system и vendor
$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

# От каких файлов зависит мод, если они меняются, мод заново накладывается
DEPS += $(wildcard $(DIR)*)

# Команды для установки libamcodec
define INSTALL =
	$(call CP,$(DIR)libamcodec.so,$(IMG.OUT)vendor/lib)
	tools/img-chmod 0755 $(IMG.OUT)vendor/lib/libamcodec.so
	grep -q "^libamcodec.so" $(IMG.OUT)system/etc/public.libraries.txt || \
	$(call FAP,$(IMG.OUT)system/etc/public.libraries.txt,libamcodec.so)
endef
