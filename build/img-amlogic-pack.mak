# Правила сборки прошивочного образа для USB Burning Tool
#
# Входные переменные:
# IMG.VAR  - (опционально) вариант прошивки (4G, 3G и т.п.)
# IMG.NAME - название формируемой прошивки (не имя файла, только название)

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(IMG.NAME),Название целевой прошивки должно быть задано в переменной IMG.NAME!)

# Генерируемый образ для USB Burning Tool
UBT.IMG = $(OUT)$(IMG.NAME)-$(VER)-$(subst /,_,$(TARGET))$(if $(IMG.VAR),_$(IMG.VAR)).img
# Конечные файлы, из которых собирается прошивка
UBT.FILES = $(addprefix $(IMG.OUT),$(IMG.COPY) $(IMG.EXT4))

HELP.ALL += $(call HELPL,ubt,Собрать прошивку в формате AmLogic USB Burning Tool)

.PHONY: ubt
ubt: $(UBT.IMG)

# Правило сборки выходной прошивки
$(UBT.IMG): $(UBT.CFG) $(UBT.FILES) $(MOD.DEPS)
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
$$(IMG.OUT)$1: $$(IMG.IN)$1 $$(IMG.OUT)file_contexts $$(IMG.OUT).stamp.unpack-$(basename $1)
	$$(TOOLS.DIR)ext4pack $$(IMG.OUT)$(basename $1) $$@ $$< $$(word 2,$$^)

endef

# Файлы из IMG.COPY напрямую копируются из исходного распакованного образа
$(foreach _,$(IMG.COPY),$(eval $(call IMG.PACK.COPY,$_)))
# Файлы из IMG.EXT4 запаковываются из распакованного каталога
$(foreach _,$(IMG.EXT4),$(eval $(call IMG.PACK.EXT4,$_)))

ifneq ($(FILE_CONTEXTS),)

# Файл контекстов для образа собирается путём слива вместе файлов
# /etc/selinux/(non|)plat_file_contexts из всех распакованных образов.
# Список файлов для сборки контекстов задаётся в платформо-зависимом файле.
$(IMG.OUT)file_contexts: $(FILE_CONTEXTS)
	cat $(wildcard $^) > $@

$(FILE_CONTEXTS): $(FILE_CONTEXTS.DEP)

endif
