# Правила сборки UPDATE.ZIP для прошивки через режим Recovery
#
# Входные переменные:
# IMG.VAR  - (опционально) вариант прошивки (4G, 3G и т.п.)
# IMG.NAME - название формируемой прошивки (не имя файла, только название)
# UPD.PART - список разделов MMC, в которые записываются соответствующие образы

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(IMG.NAME),Название целевой прошивки должно быть задано в переменной IMG.NAME!)

# Название файла
UPD.ZIP = $(OUT)update-$(IMG.NAME)-$(VER)-$(subst /,_,$(TARGET))$(if $(IMG.VAR),_$(IMG.VAR)).zip
# Конечные файлы, из которых собирается прошивка
UPD.FILES = $(addprefix $(IMG.OUT),$(filter $(addsuffix .%,$(UPD.PART)),\
	$(IMG.COPY) $(addsuffix .raw,$(IMG.EXT4))))

HELP.ALL += $(call HELPL,upd,Собрать UPDATE.ZIP для прошивки через Recovery)

.PHONY: upd
upd: $(UPD.ZIP)

# Правило сборки выходной прошивки
$(UPD.ZIP): $(UPD.FILES) | $(MOD.DEPS)
	tools/upd-maker "$(IMG.NAME)" $@ $^

# Правило для распаковки sparse образа в raw
%.PARTITION.raw: %.PARTITION
	$(TOOLS.DIR)simg2img $< $@
