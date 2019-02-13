# Название прошивки
FIRMNAME = Volksware
# Название целевого устройства (без пробелов)
DEVICE = X96Max
# Вариант прошивки, значение по умолчанию
VARIANT ?= 4G
# Название аппаратной платформы (ro.product.device)
PRODEV = u211
# Название файла базовой прошивки
IMG.BASE = GT1-mini_115N0.img
# В eMMC под /dev/block/vendor выделено 1.1Gb, а образ ФС всего на 256Мб
EXT4.SIZE.vendor=1174405120
# Предпочтительная архитектура для библиотек в устанавливаемых APK
# (через пробел в порядке уменьшения приоритета)
APKARCH=armeabi-v7a armeabi

# Добавляем суффикс к каталогу OUT в зависимости от варианта прошивки
OUT := $(OUT)$(VARIANT)/

# Правила для вычисления номера версии
include build/version.mak

# Добавляем правила распаковки исходного образа
include build/img-amlogic-unpack.mak

# Контексты SELinux для каждого из ext4 разделов
FILE_CONTEXTS.vendor = $(IMG.OUT)system/etc/selinux/plat_file_contexts \
	$(IMG.OUT)vendor/etc/selinux/nonplat_file_contexts \
	$(IMG.OUT)vendor_contexts
FILE_CONTEXTS.system = $(IMG.OUT)vendor/etc/selinux/nonplat_file_contexts \
	$(IMG.OUT)system/etc/selinux/plat_file_contexts \
	$(IMG.OUT)system_contexts

# Чтобы эти файлы существовали, надо чтобы соответствующий образ ext4 был распакован
FILE_CONTEXTS.DEP += $(IMG.OUT).stamp.unpack-system $(IMG.OUT).stamp.unpack-vendor

# Теперь правила для наложения модификаций
include build/mod.mak

# Правила упаковки конечного образа
include build/img-amlogic-pack.mak

# Также мы хотим образ для прошивки через Recovery
UPD.PART = system vendor boot _aml_dtb
include build/recovery-pack.mak

# Список файлов, которые попадают в релиз
DEPLOY = $(UBT.IMG) $(UPD.ZIP)

# Правила для сборки релиза
include build/deploy.mak
