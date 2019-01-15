HELP.ALL += $(call HELPL,help-mod,Цели для наложения отдельных модификаций на прошивку)
HELP.ALL += $(call HELPL,mod,Выполнить все рецепты модификации образа)

# Функция загружает рецепт мода из .mak файла
define MOD.INCLUDE
# Обнуляем переменные, которые устанавливают моды
# Строка описания мода
HELP :=
# Команды для установки мода
INSTALL :=

# Название цели вычисляем по имени каталога
MOD := $$(basename $$(notdir $1))
# Переменная DIR содержит путь к каталогу мода
DIR := $$(dir $1)
# Файл штампа готовности мода
STAMP := $$(IMG.OUT).stamp.mod-$$(MOD)
# Файлы, от которых зависит мод
DEPS := $$(wildcard $$(DIR)*)

include $1

$$(call ASSERT,$$(INSTALL),$$(MOD): Вы должны определить команды в переменной INSTALL)
HELP.MOD := $$(HELP.MOD)$$(call HELPL,mod-$$(MOD),$$(HELP))

INSTALL.mod-$1 := $$(INSTALL)

.PHONY: mod-$$(MOD)
mod-$$(MOD): $$(STAMP)

$$(STAMP): $$(DEPS)
	$$(call MKDIR,$$(@D))
	$$(INSTALL.mod-$1)
	$$(call TOUCH,$$@)

MOD.DEPS := $(MOD.DEPS) $$(STAMP)
endef

# Загрузим все рецепты (патчи, дополнения и т.п.), которые есть для нашей платформы
$(foreach _,$(wildcard $(TARGET.DIR)*/*.mak),$(eval $(call MOD.INCLUDE,$_)))

.PHONY: mod help-mod
mod: $(MOD.DEPS)

help-mod:
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.MOD))
	@$(call SAY,$(C.SEP)$-$(C.RST))
