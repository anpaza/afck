# Правила сборки и разборки прошивочного образа для чипов AMLogic
#
# Входные переменные:
# IMG.BASE - название файла базовой прошивки (файл должен находиться в ingredients/)

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(IMG.BASE),Название файла с базовой прошивкой должно быть задано в переменной IMG.BASE!)

# Каталог, куда распаковывается базовая прошивка
IMG.IN = $(OUT)img-unpack/
# Каталог, где будут формироваться конечные составные части прошивки (boot, system, vendor и т.п.)
IMG.OUT = $(OUT)img-ubt/

HELP.ALL += $(call HELPL,img-unpack,Извлечь компоненты из исходного образа)

# Файл с конфигурацией прошивки для USB Burning Tool
UBT.CFG = $(TARGET.DIR)image.cfg
# Список файлов-компонентов *конечной* прошивки UBT
IMG.COPY = $(call AML_IMG_CFG,$(UBT.CFG),files)

.PHONY: img-unpack
img-unpack: $(IMG.IN).stamp.unpack

# Штамп распаковки исходного образа ставится после распаковки исходного образа :)
$(IMG.IN).stamp.unpack: ingredients/$(IMG.BASE) $(IMG.IN).stamp.dir
	$(TOOLS.DIR)aml_image_v2_packer -d $< $(@D)
	$(call TOUCH,$@)

# Функция вызывается для компоненты базового образа в формате ext4,
# которую нужно распаковать. Если вызвать функцию несколько раз для
# одного и того же компонента, функция ничего не делает.
# Аргументы:
# $1 - название компонента, который нужно распаковать (system, vendor итд)
#
# Функция добавляет необходимые зависимости в переменную DEPS.
define IMG.UNPACK.EXT4
$(if $(filter $1.PARTITION,$(IMG.COPY)),$(eval $(call IMG.UNPACK.EXT4_,$1)))
$(eval DEPS := $(DEPS) $(IMG.OUT).stamp.unpack-$1)
endef

define IMG.UNPACK.EXT4_
IMG.EXT4 := $(IMG.EXT4) $$(filter $1.PARTITION,$$(IMG.COPY))
IMG.COPY := $$(filter-out $1.PARTITION,$$(IMG.COPY))

# Штамп распаковки исходного образа ext4 зависит от файла образа раздела
$$(IMG.OUT).stamp.unpack-$1: $$(IMG.IN)$1.PARTITION
	$$(call RMDIR,$$(IMG.OUT)$1)
	$$(call MKDIR,$$(IMG.OUT)$1)
	$$(call EXT4.UNPACK,$$<,$$(IMG.OUT)$1)
	$$(call TOUCH,$$@)

# Исходный образ ext4 зависит от штампа распаковки исходного образа
$$(IMG.IN)$1.PARTITION: $$(IMG.IN).stamp.unpack
endef
