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

HELP.ALL += $(call HELPL,help-img,Дополнительные команды для работы с образами)
HELP.ALL += $(call HELPL,img-unpack,Извлечь компоненты из исходного образа)

# Файл с конфигурацией прошивки для USB Burning Tool
UBT.CFG = $(TARGET.DIR)image.cfg
# Список файлов-компонентов конечной прошивки UBT, которые получаются копированием
# Изначально предполагается, что все компоненты будут скопированы. По мере обработки
# рецептов компоненты могут перемещаться из IMG.COPY в IMG.EXT4 (для образов ext4,
# которые разбираются а затем собираются обратно) и IMG.BUILD (для файлов, которые
# каким-то образом генерируются).
IMG.COPY = $(shell tools/aml-img-cfg "$(UBT.CFG)" files)

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
IMG.EXT4 := $$(IMG.EXT4) $$(filter $1.PARTITION,$$(IMG.COPY))
IMG.COPY := $$(filter-out $1.PARTITION,$$(IMG.COPY))

# Штамп распаковки исходного образа ext4 зависит от файла образа раздела
$$(IMG.OUT).stamp.unpack-$1: $$(IMG.IN)$1.PARTITION
	$$(call RMDIR,$$(IMG.OUT)$1)
	$$(call MKDIR,$$(IMG.OUT)$1)
	$$(call EXT4.UNPACK,$$<,$$(IMG.OUT)$1)
	$$(call TOUCH,$$(IMG.OUT)$1_contexts)
	$$(call TOUCH,$$@)

# Исходный образ ext4 зависит от штампа распаковки исходного образа
$$(IMG.IN)$1.PARTITION: $$(IMG.IN).stamp.unpack

HELP.IMG += $$(call HELPL,clean-img-$1,Очистить распакованный образ $1)
.PHONY: clean-img-$1
clean-img-$1:
	rm -f $$(IMG.OUT).stamp.unpack-$1 $$(IMG.OUT)$1_contexts
	rm -rf $$(IMG.OUT)$1
endef

# Функция помечает компонент прошивки как собираемый в модах.
# Для таких компонентов не генерируются правила его создания
# (копированием или собиранием из "рассыпухи").
#
# $1 - название вручную собираемого компонента (_aml_dtb, bootlogo итд)
define IMG.WILL.BUILD
$(if $(filter $1.%,$(IMG.COPY)),$(eval $(call IMG.WILL.BUILD_,$1)))
endef

define IMG.WILL.BUILD_
IMG.BUILD := $$(IMG.BUILD) $$(filter $1.%,$$(IMG.COPY))
IMG.COPY := $$(filter-out $1.%,$$(IMG.COPY))
endef

.PHONY: help-img
help-img:
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.IMG))
	@$(call SAY,$(C.SEP)$-$(C.RST))
