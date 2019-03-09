# Правила сборки прошивочного образа для USB Burning Tool
#
# Входные переменные:
# VARIANT  - (опционально) вариант прошивки (4G, 3G и т.п.)
# FIRMNAME - название формируемой прошивки (не имя файла, только название)

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(FIRMNAME),Название целевой прошивки должно быть задано в переменной FIRMNAME!)

# Генерируемый образ для USB Burning Tool
UBT.IMG = $(OUT)$(FIRMNAME)-$(VER)-$(DEVICE)$(if $(VARIANT),_$(VARIANT)).img
# Конечные файлы, из которых собирается прошивка
UBT.FILES = $(addprefix $(IMG.OUT),$(IMG.COPY) $(IMG.EXT4) $(IMG.BUILD))

HELP.ALL += $(call HELPL,ubt,Собрать прошивку в формате AmLogic USB Burning Tool)
HELP.ALL += $(call HELPL,help-ubt,Вывести список отдельно собираемых компонент для UBT)

HELP.UBT += $(call HELPL,ubt-img,Собрать все образы$(COMMA) из которых собирается прошивка)

.PHONY: ubt ubt-img
ubt: $(UBT.IMG)
ubt-img: $(UBT.FILES)

# Правило сборки выходной прошивки
$(UBT.IMG): $(UBT.CFG) $(UBT.FILES)
	$(TOOLS.DIR)aml_image_v2_packer -r $< $(IMG.OUT) $@

# Чтобы сделать образы разделов, нужно сначало наложить моды
$(UBT.FILES): $(MOD.DEPS)

# Правила для файлов прошивки, не требующих модификации (прямое копирование)
# $1 - название файла компонента прошивки
# $2 - (опционально) название исходного файла компонента
define IMG.PACK.COPY
# Файл в выходном каталоге зависит от файла во входном каталоге
$$(IMG.OUT)$1: $$(if $2,$2,$$(IMG.IN)$1)
	$$(call CP,$$<,$$@)

# Наличие файла во входном каталоге зависит от штампа распаковки исходного образа
$$(IMG.IN)$1: $$(IMG.IN).stamp.unpack

endef

# Правила для сборки образа ext4
define IMG.PACK.EXT4
.PHONY: ubt-$(basename $1)
ubt-$(basename $1): $$(IMG.OUT)$1
HELP.UBT += $$(call HELPL,ubt-$(basename $1),Собрать $$(IMG.OUT)$1)

# Чтобы получить конечный образ ext4, надо запаковать распакованный образ
$$(IMG.OUT)$1: $$(IMG.OUT)$(basename $1)_contexts.all $$(IMG.OUT).stamp.unpack-$(basename $1)
	$$(TOOLS.DIR)ext4pack -d $$(IMG.OUT)$(basename $1) -o $$@ -c $$< \
	$$(if $$(EXT4.SIZE.$(basename $1)),-s $$(EXT4.SIZE.$(basename $1)),-O $$(IMG.IN)$1)

$$(IMG.OUT)$(basename $1)_contexts.all: $$(FILE_CONTEXTS.$(basename $1))
	tools/merge-contexts $$^ >$$@

$$(FILE_CONTEXTS.$(basename $1)): $$(IMG.OUT).stamp.unpack-$(basename $1) $(MOD.DEPS)

endef

# Файлы из IMG.COPY напрямую копируются из исходного распакованного образа
$(foreach _,$(IMG.COPY),$(eval $(call IMG.PACK.COPY,$_)))
# Файлы из IMG.EXT4 запаковываются из распакованного каталога
$(foreach _,$(IMG.EXT4),$(eval $(call IMG.PACK.EXT4,$_)))
# Файлы из IMG.BUILD собираются по правилам в самих модах

.PHONY: help-ubt
help-ubt:
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.UBT))
	@$(call SAY,$(C.SEP)$-$(C.RST))
