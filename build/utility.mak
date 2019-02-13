# Полезные функции, которыми не стоит засорять rules.mak

#-------------------------------------------------------------------------------
# Наложить патч $1 относительно каталога $2 с дополнительными опциями $3
define APPLY.PATCH
	@$(call SAY,$(C.HEAD)Applying patch file $(C.BOLD)$1$(C.RST))
	patch $(if $2,-d "$2") $3 <$(if $1,"$1")

endef

APKTOOL = java -jar tools/apktool_2.3.4.jar
ZIPSIGNER = java -jar tools/zipsigner-3.0.jar

#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
# Проверить наличие файла $1, если нет - выводится ошибка
define ASSERT.FILE
$(call ASSERT,$(wildcard $1),$(if $(MOD),Для мода $(C.EMPH)$(MOD)$(C.ERR) н,Н)еобходим файл '$(C.BOLD)$1$(C.ERR)')
endef

#-------------------------------------------------------------------------------
# Установка APK в прошивку системным приложением
# $1 - название раздела (system, vendor, ...)
# $2 - название файла APK (без каталога, должен лежать в ingredients/)
# $3 - описание APK
MOD.SYSAPK = $(eval $(call MOD.SYSAPK_,$1,$2,$3))

MOD.SYSAPK.CON.system = u:object_r:system_file:s0
MOD.SYSAPK.CON.vendor = u:object_r:vendor_app_file:s0

define MOD.SYSAPK_
ifeq ($(DISABLED),)
$$(call ASSERT.FILE,ingredients/$2)
endif

HELP = $3

$(call IMG.UNPACK.EXT4,$1)

define INSTALL
	tools/img-instapk -a "$(APKARCH)" -c $(MOD.SYSAPK.CON.$1) -d $/$1/app/$(basename $2) ingredients/$2

endef
endef

#-------------------------------------------------------------------------------
# Установка APK в прошивку пользовательским приложением.
# Требует наличия в прошивке модуля preinstall.
# $1 - название файла APK (без каталога, должен лежать в ingredients/)
# $2 - описание APK
MOD.USERAPK = $(eval $(call MOD.USERAPK_,$1,$2))

define MOD.USERAPK_
ifeq ($(DISABLED),)
$$(call ASSERT.FILE,ingredients/$1)
endif

HELP = $2

$(call IMG.UNPACK.EXT4,vendor)

define INSTALL
	mkdir -p $/vendor/preinstall
	cp ingredients/$1 $/vendor/preinstall
	tools/img-perm -m 0644 -c u:object_r:vendor_app_file:s0 $/vendor/preinstall/$1

endef
endef
