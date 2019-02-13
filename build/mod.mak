HELP.ALL += $(call HELPL,mod,Выполнить все рецепты модификации образа)
HELP.ALL += $(call HELPL,help-mod,Цели для наложения отдельных модификаций на прошивку)

# Функция загружает рецепт мода из .mak файла.
# Результат выполнения функции является кодом для Make, который затем интерпретируется
# функцией eval. Поэтому работа функции производится в два этапа: на первом этапе
# составляется *текст*, на втором этапе этот текст интерпретируется как *код*.
# В раскрытиях, которые необходимо отложить на второй этап, следует использовать
# двойной знак доллара $$(), чтобы на первом этапе оно превратилось в обычное
# раскрытие $(), а уже на втором этапе раскрытие реально произошло.
define MOD.INCLUDE
# Обнуляем переменные, которые устанавливают моды
# Строка описания мода
HELP :=
# Команды для установки мода
INSTALL :=
# По умолчанию модуль включён
DISABLED :=
# Многострочное описание мода для файла README
DESC :=

# Название цели вычисляем по имени каталога
MOD := $$(basename $$(notdir $1))
# Переменная DIR содержит путь к каталогу мода
DIR := $$(dir $1)
# Файл штампа готовности мода
STAMP := $$(IMG.OUT).stamp.mod-$$(MOD)
# Файлы, от которых зависит мод
DEPS := $$(wildcard $$(DIR)*)
# Для упрощения, базовый каталог, куда распаковываются разделы
/ := $$(IMG.OUT)

include $1

ifeq ($$(DISABLED),)
$$(call ASSERT,$$(INSTALL),$$(MOD): Вы должны определить команды в переменной INSTALL)
HELP.MOD := $$(HELP.MOD)$$(call HELPL,mod-$$(MOD),$$(HELP))

INSTALL.mod-$$(MOD) := $$(INSTALL)
STAMP.mod-$$(MOD) := $$(STAMP)
HELP.mod-$$(MOD) := $$(HELP)
DESC.mod-$$(MOD) := $$(DESC)

.PHONY: mod-$$(MOD)
mod-$$(MOD): $$(STAMP.mod-$$(MOD))

# В командах нельзя использовать переменные, определённые выше,
# т.к. они интерпретируются непосредственно во время eval.
$$(STAMP.mod-$$(MOD)): $$(DEPS)
	$$(call MKDIR,$$(@D))
	$$(INSTALL.mod-$(basename $(notdir $1)))
	$$(call TOUCH,$$@)

MOD.DEPS := $$(MOD.DEPS) $$(STAMP.mod-$$(MOD))
MOD.ALL := $$(MOD.ALL) $$(MOD)
endif
endef

# Загрузим все рецепты (патчи, дополнения и т.п.), которые есть для нашей платформы
$(foreach _,$(sort $(wildcard $(TARGET.DIR)*/*.mak)),$(eval $(call MOD.INCLUDE,$_)))

.PHONY: mod help-mod mod-help mod-doc
mod: $(MOD.DEPS)

help-mod mod-help:
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.MOD))
	@$(call SAY,$(C.SEP)$-$(C.RST))

show-rules:
	$(call SAY,$(foreach _,$(sort $(wildcard $(TARGET.DIR)*/*.mak)),$(call MOD.INCLUDE,$_)$(NL)))

MOD.DOC = $(OUT)$(FIRMNAME)-$(VER)-$(DEVICE)$(if $(VARIANT),_$(VARIANT)).md
DEPLOY += $(MOD.DOC)
mod-doc: $(MOD.DOC)

MOD.DOC.MAKE = $(foreach _,$(MOD.ALL),$(call MOD.DOC.MAKE_,$_))
define MOD.DOC.MAKE_

* $_ - $(HELP.mod-$1)
$(if $(DESC.mod-$1),  $(DESC.mod-$1))
endef

# Замена в докуметнации специальных тегов на значения переменных
MOD.SEDREPL = -e 's/@FIRMNAME@/$(FIRMNAME)/g' \
	      -e 's/@VER@/$(VER)/g' \
	      -e 's/@DEVICE@/$(DEVICE)/g' \
	      -e 's/@VARIANT@/$(VARIANT)/g'

$(MOD.DOC): $(MAKEFILE_LIST)
	sed $(TARGET.DIR)/README-head.md $(MOD.SEDREPL) >$@
	@$(call SAY,$(call MOD.DOC.MAKE)) | sed $(MOD.SEDREPL) >>$@
	sed $(TARGET.DIR)/README-tail.md $(MOD.SEDREPL) >>$@
