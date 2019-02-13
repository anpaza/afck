HELP = Очистка прошивка Beelink от мусора

$(call IMG.UNPACK.EXT4,system)
$(call IMG.UNPACK.EXT4,vendor)

# Разъяснение по удалению APK-шек:
#  * AppMarket какое-то неработающее дерьмо
#  * Music он же Bee Music он же "Вы хотите выйти плеер?" -> "О да!".
#  * CompanionDeviceManager нерабочая хрень
#    (am start-activity -a android.companiondevice.START_DISCOVERY
#    -> в приложении com.android.companiondevicemanager произошёл сбой).
#  * FileManager знаменитый "пчела файлы", в представлении не нуждается
#  * WAPPushManager - что-то про WAP, у нас не телефон
#  * FotaUpdate* - обновление кончится плохо для пользователя
#  * NativeImagePlayer - страшненький просмотр картинок
#  * FileBrowser - заменяется на Total Commander
#  * AppInstaller - заменяется на XAPK Installer
define INSTALL
	tools/sed-patch -e '/preinstall Apks/$(COMMA)/^$$/d' \
		-e '/^.HDMI IN/$(COMMA)/^$$/d' \
		$/vendor/etc/init/hw/init.amlogic.board.rc
	rm -f $/system/bin/preinstallApks.sh 
	rm -rf $/system/usr/trigtop
	rm -rf $(addprefix $/system/app/,AppMarket BeeMusic Music \
		CompanionDeviceManager FileManager \
		WAPPushManager FotaUpdate FotaUpdateReboot)
	rm -rf $(addprefix $/vendor/app/,OTAUpgrade NativeImagePlayer \
		FileBrowser AppInstaller)
endef
