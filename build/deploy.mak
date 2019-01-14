# Каталог, куда складывается релиз
DEPLOY.DIR = $(OUT)deploy/$(VARIANT)/

HELP.ALL += $(call HELPL,deploy,Собрать релиз в каталоге $(DEPLOY.DIR))

DEPLOY.FILES += $(addprefix $(DEPLOY.DIR),$(notdir $(DEPLOY)))

.PHONY: deploy
deploy: $(DEPLOY.FILES) | $(DEPLOY.DIR).stamp.dir

# В простейшем случае просто перемещаем файлы из $OUT в каталог релиза
$(DEPLOY.DIR)%: $(OUT)%
	$(call MV,$<,$@)
