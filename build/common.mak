.PHONY: help clean

HELP.HDR :=
HELP.ALL :=

HELP.HDR += Базисная ОС: $(C.BOLD)$(HOST.OS)$(C.RST), целевая платформа: $(C.BOLD)$(TARGET)$(C.RST)$(NL)
HELP.ALL += $(call HELPL,clean,Удалить все сгенерированные файлы)

# Вывод текста помощи
help:
	@$(call SAY,$(C.SEP)$-$(C.RST))
	@$(call SAY,$(HELP.HDR))
	@$(call SAY,$(C.HEAD)Выберите цель для сборки:$(C.RST))
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.ALL))
	@$(call SAY,$(C.SEP)$-$(C.RST))

# Полная очистка каталога с созданными файлами
clean:
	$(call RMDIR,$(OUT))

# Правило для создания файла штампа каталога.
# Штамп каталога используется для предотвращения нежелательных пересборок
# зависимых целей, т.к. при создании файлов в каталоге его штамп времени
# последней модификации также меняется, поэтому мы не можем зависеть
# напрямую от самого каталога.
%/.stamp.dir:
	$(call MKDIR,$(@D))
	$(call TOUCH,$@)
