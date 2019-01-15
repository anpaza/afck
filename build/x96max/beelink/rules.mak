# Название прошивки
FIRMNAME = volksware
# Вариант прошивки, значение по умолчанию
VARIANT ?= 4G
# Название аппаратной платформы (ro.product.device)
PRODEV = u211
# Название файла базовой прошивки
IMG.BASE = GT1-mini_114N0.img

# Правила для вычисления номера версии
include build/version.mak

# Добавляем правила распаковки исходного образа
include build/img-amlogic-unpack.mak

# Контексты SELinux имеются прямо в прошивке
FILE_CONTEXTS += \
	$(IMG.OUT)system/etc/selinux/plat_file_contexts \
	$(IMG.OUT)vendor/etc/selinux/nonplat_file_contexts

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
