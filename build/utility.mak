# Полезные функции, которыми не стоит засорять rules.mak

# Наложить патч $1 относительно каталога $2 с дополнительными опциями $3
define APPLY.PATCH
	@$(call SAY,$(C.HEAD)Applying patch file $(C.BOLD)$1$(C.RST))
	patch $(if $2,-d "$2") $3 <$(if $1,"$1")

endef

APKTOOL = java -jar tools/apktool_2.3.4.jar
ZIPSIGNER = java -jar tools/zipsigner-3.0.jar

# Наложить на APK $1 последовательно патчи из каталога $2
define APPLY.PATCH.APK
	@$(call SAY,$(C.HEAD)Patching APK file $(C.BOLD)$1$(C.RST))
	$(APKTOOL) decode -o $(OUT)patch-$(notdir $1) -f $1
	$(foreach _,$(sort $(wildcard $(realpath $2)/*.patch)),$(call APPLY.PATCH,$_,$(OUT)patch-$(notdir $1),-p1))
	$(APKTOOL) build -o $1_ $(OUT)patch-$(notdir $1)
	$(call RMDIR,$(OUT)patch-$(notdir $1))
	$(ZIPSIGNER) $1_ $1
	$(call RM,$1_)
endef

# Проверить наличие файла $1, если нет - выводится ошибка
define ASSERT.FILE
$(call ASSERT,$(wildcard $1),$(if $(MOD),Для мода $(C.EMPH)$(MOD)$(C.ERR) )требуется файл '$(C.BOLD)$1$(C.ERR)')
endef

# Установка APK в прошивку
# $1 - system или vendor
# $2 - название файла APK (без каталога, должен лежать в ingredients/)
# $3 - описание APK
MOD.APK = $(eval $(call MOD.APK_,$1,$2,$3))

MOD.APK.CON.system = u:object_r:system_file:s0
MOD.APK.CON.vendor = u:object_r:vendor_app_file:s0

define MOD.APK_
$(call ASSERT.FILE,ingredients/$2)

HELP = $3

$(call IMG.UNPACK.EXT4,$1)

define INSTALL
	mkdir -p $/$1/app/$(basename $2)
	cp ingredients/$2 $/$1/app/$(basename $2)/$2
	tools/img-perm -m 0755 -c $(MOD.APK.CON.$1) $/$1/app/$(basename $2)
	tools/img-perm -m 0644 -c $(MOD.APK.CON.$1) $/$1/app/$(basename $2)/$2
endef
endef
