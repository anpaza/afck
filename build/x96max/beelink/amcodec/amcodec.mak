#---------------------------------
# Установка libamcodec в прошивку
#---------------------------------

# Описание мода
HELP = Установка libamcodec.so

# Для модификации нам нужны распакованные разделы system и vendor
$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

# Команды для установки libamcodec
define INSTALL
	cp -a $(DIR)libamcodec.so $/vendor/lib
	tools/img-perm 0755 u:object_r:vendor_file:s0 $/vendor/lib/libamcodec.so
	grep -q "^libamcodec.so" $/system/etc/public.libraries.txt || \
	echo "libamcodec.so" >> $/system/etc/public.libraries.txt
endef
