# Правила сборки прошивочного образа для USB Burning Tool
#
# Входные переменные:
# VARIANT  - (опционально) вариант прошивки (4G, 3G и т.п.)
# FIRMNAME - название формируемой прошивки (не имя файла, только название)

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(FIRMNAME),Название целевой прошивки должно быть задано в переменной FIRMNAME!)

# Генерируемый образ для USB Burning Tool
UBT.IMG = $(OUT)$(FIRMNAME)-$(VER)-$(subst /,_,$(TARGET))$(if $(VARIANT),_$(VARIANT)).img
# Конечные файлы, из которых собирается прошивка
UBT.FILES = $(addprefix $(IMG.OUT),$(IMG.COPY) $(IMG.EXT4) $(IMG.BUILD))

HELP.ALL += $(call HELPL,ubt,Собрать прошивку в формате AmLogic USB Burning Tool)

.PHONY: ubt
ubt: $(UBT.IMG)

# Правило сборки выходной прошивки
$(UBT.IMG): $(UBT.CFG) $(UBT.FILES) | $(MOD.DEPS)
	$(TOOLS.DIR)aml_image_v2_packer -r $< $(IMG.OUT) $@

# Правила для файлов прошивки, не требующих модификации (прямое копирование)
define IMG.PACK.COPY
# Файл в выходном каталоге зависит от файла во входном каталоге
$$(IMG.OUT)$1: $$(IMG.IN)$1
	$$(call CP,$$<,$$@)

# Наличие файла во входном каталоге зависит от штампа распаковки исходного образа
$$(IMG.IN)$1: $$(IMG.IN).stamp.unpack

endef

# Правила для сборки образа ext4
define IMG.PACK.EXT4
# Чтобы получить конечный образ ext4, надо запаковать распакованный образ
$$(IMG.OUT)$1: $$(IMG.IN)$1 $$(IMG.OUT)$(basename $1)_contexts.all $$(IMG.OUT).stamp.unpack-$(basename $1)
	$$(TOOLS.DIR)ext4pack $$(IMG.OUT)$(basename $1) $$@ $$< $$(word 2,$$^)

$$(IMG.OUT)$(basename $1)_contexts.all: $$(FILE_CONTEXTS.$(basename $1))
	tools/merge-contexts $$^ >$$@

$$(FILE_CONTEXTS.$(basename $1)): $$(IMG.OUT).stamp.unpack-$(basename $1)

endef

# Файлы из IMG.COPY напрямую копируются из исходного распакованного образа
$(foreach _,$(IMG.COPY),$(eval $(call IMG.PACK.COPY,$_)))
# Файлы из IMG.EXT4 запаковываются из распакованного каталога
$(foreach _,$(IMG.EXT4),$(eval $(call IMG.PACK.EXT4,$_)))
# Файлы из IMG.BUILD собираются по правилам в самих модах
