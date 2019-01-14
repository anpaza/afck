# Правила для отслеживания номера версии прошивки

# Текущий номер версии содержится в подкаталоге целевой платформы
include $(TARGET.DIR)/img-version.mak

# Сформируем полный номер версии
VER = $(strip $(VER.HI)).$(strip $(VER.LO)).$(strip $(VER.REV))

HELP.HDR += Прошивка: $(C.BOLD)$(FIRMNAME)$(C.RST) версия: $(C.BOLD)$(VER)$(C.RST)$(NL)
HELP.ALL += $(call HELPL,help-ver,Цели для манипуляций с номером версии)

HELP.VER += $(call HELPL,ver_next_hi,Увеличить старший номер версии ($(VER.HI) -> $(call ADD,$(VER.HI),1)))
HELP.VER += $(call HELPL,ver_next_lo,Увеличить младший номер версии ($(VER.LO) -> $(call ADD,$(VER.LO),1)))
HELP.VER += $(call HELPL,ver_next_rev,Увеличить номер ревизии ($(VER.REV) -> $(call ADD,$(VER.REV),1)))

VER.UPDATE = $(call FWRITE,$(TARGET.DIR)/img-version.mak,VER.HI=$1$(NL)VER.LO=$2$(NL)VER.REV=$3)

.PHONY: ver_show ver_next_rev ver_next_lo ver_next_hi
ver_show:
	@$(call SAY,Target image version: $(C.BOLD)$(VER)$(C.RST))
ver_next_rev:
	$(call VER.UPDATE,$(VER.HI),$(VER.LO),$(call ADD,$(VER.REV),1))
	@$(MAKE) --no-print-directory ver_show
ver_next_lo:
	$(call VER.UPDATE,$(VER.HI),$(call ADD,$(VER.LO),1),0)
	@$(MAKE) --no-print-directory ver_show
ver_next_hi:
	$(call VER.UPDATE,$(call ADD,$(VER.HI),1),0,0)
	@$(MAKE) --no-print-directory ver_show

.PHONY: help-ver
help-ver:
	@$(call SAY,$(C.SEP)$-$(C.RST)$(HELP.VER))
	@$(call SAY,$(C.SEP)$-$(C.RST))
