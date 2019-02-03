HELP = Замена для vold, позволяющая автоматически монтировать ext2/3/4

$(call IMG.UNPACK.EXT4,system)

define INSTALL
	lzma -dc $(DIR)vold.lzma > $/system/bin/vold
	tools/img-perm -m 0755 -c u:object_r:vold_exec:s0 $/system/bin/vold
endef
