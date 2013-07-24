#!/bin/bash

PRODUCTD:=	bin/siu.swf
PRODUCTR:=	bin/siu-release.swf
SOURCE	:=	src/Main.as
SOURCES	:=	src
LIBS	:=	assets/Fonts.swc
DEPS	:=	bin/makedeps.in
FLASH	:=	flashplayerdebugger

#export FLEX_HOME=/opt/flex3

MXMLC	:=	$(FLEX_HOME)/bin/mxmlc

FLAGS	:=	-target-player 10 \
			-default-size=1280,720 \
			-default-background-color=\#000000 \
			-default-frame-rate=60 \
			-static-link-runtime-shared-libraries=true \
			-compiler.source-path+=src
DEFINES	:=	CONFIG::air,false \
			CONFIG::desktop,false
DEFINESD:=	CONFIG::debug,true CONFIG::release,false
DEFINESR:=	CONFIG::debug,false CONFIG::release,true

FLAGS	:=	$(FLAGS) \
			$(foreach def,$(DEFINES),-compiler.define+=$(def)) \
			$(foreach src,$(SOURCES),-compiler.source-path+=$(src)) \
			$(foreach lib,$(LIBS),-compiler.library-path+=$(lib))

FLAGSD	:=	$(FLAGS) \
			$(foreach def,$(DEFINESD),-compiler.define+=$(def)) \
			-debug=true \
			-incremental=true
FLAGSR	:=	$(FLAGS) \
			$(foreach def,$(DEFINESR),-compiler.define+=$(def)) \
			-compiler.optimize=true \
			-debug=false \
			-incremental=false

all: $(PRODUCTD)
release: $(PRODUCTR)


run: $(PRODUCTD)
	$(FLASH) $(PRODUCTD)

$(PRODUCTD):
	$(MXMLC) $(FLAGSD) $(SOURCE) -output=$(PRODUCTD)

$(PRODUCTR):
	$(MXMLC) $(FLAGSR) $(SOURCE) -output=$(PRODUCTR)

PRODUCTD_SED	:=	$(subst /,\/,$(PRODUCTD))
PRODUCTR_SED	:=	$(subst /,\/,$(PRODUCTR))
gendeps:
	find $(SOURCES) -name '*.as' | sed 's/^src\//$(PRODUCTD_SED): src\//' > $(DEPS)
	find $(SOURCES) -name '*.as' | sed 's/^src\//$(PRODUCTR_SED): src\//' >> $(DEPS)

-include $(DEPS)

.PHONY: all run gendeps shell loader release
