# Полезные функции, которыми не стоит засорять rules.mak

# Наложить патч $1 относительно каталога $2 с дополнительными опциями $3
define APPLY.PATCH
	@$(call SAY,$(C.WHITE)Applying patch file $(C.LBLUE)$1$(C.RST))
	patch $(if $2,-d "$2") $3 <$(if $1,"$1")

endef

APKTOOL = java -jar tools/apktool_2.3.4.jar
ZIPSIGNER = java -jar tools/zipsigner-3.0.jar

# Наложить на APK $1 последовательно патчи из каталога $2
define APPLY.PATCH.APK
	@$(call SAY,$(C.WHITE)Patching APK file $(C.LBLUE)$1$(C.RST))
	$(APKTOOL) decode -o $(OUT)apktool -f $1
	$(foreach _,$(sort $(wildcard $(realpath $2)/*.patch)),patch -d $(OUT)apktool -p1 -i $_ $(NL))
	$(APKTOOL) build -o _$1 $(OUT)apktool
	$(call RMDIR,$(OUT)apktool)
	$(ZIPSIGNER) _$1 $1
	$(call RM,_$1)
endef
