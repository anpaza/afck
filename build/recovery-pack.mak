# Правила сборки UPDATE.ZIP для прошивки через режим Recovery
#
# Входные переменные:
# VARIANT  - (опционально) вариант прошивки (4G, 3G и т.п.)
# FIRMNAME - название формируемой прошивки (не имя файла, только название)
# UPD.PART - список разделов MMC, в которые записываются соответствующие образы

# Проверить, что все исходные данные заданы корректно
$(call ASSERT,$(FIRMNAME),Название целевой прошивки должно быть задано в переменной FIRMNAME!)
$(call ASSERT,$(PRODEV),Название устройства (ro.product.device) должно быть задано в переменной PRODEV!)

# Название файла
UPD.ZIP = $(OUT)update-$(FIRMNAME)-$(VER)-$(subst /,_,$(TARGET))$(if $(VARIANT),_$(VARIANT)).zip
# Конечные файлы, из которых собирается прошивка
UPD.FILES = $(addprefix $(IMG.OUT),$(filter $(addsuffix .%,$(UPD.PART)),\
	$(IMG.COPY) $(addsuffix .raw,$(IMG.EXT4))))

HELP.ALL += $(call HELPL,upd,Собрать UPDATE.ZIP для прошивки через Recovery)

.PHONY: upd
upd: $(UPD.ZIP)

# Правило сборки выходной прошивки
$(UPD.ZIP): $(UPD.FILES) | $(MOD.DEPS)
	tools/upd-maker "$(FIRMNAME)" "$(PRODEV) $(VER)" $@ $^

# Правило для распаковки sparse образа в raw
%.PARTITION.raw: %.PARTITION
	$(TOOLS.DIR)simg2img $< $@
