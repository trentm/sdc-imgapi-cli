#
# Copyright (c) 2014, Joyent, Inc. All rights reserved.
#
# Makefile for IMGAPI
#

#
# Vars, Tools, Files, Flags
#
NAME		:= imgapi-cli
JS_FILES	:= $(shell find lib test -name '*.js' | grep -v '/tmp/')
JSL_CONF_NODE	 = tools/jsl.node.conf
JSL_FILES_NODE	 = $(JS_FILES)
JSSTYLE_FILES	 = $(JS_FILES)
JSSTYLE_FLAGS	 = -f tools/jsstyle.conf
NODEUNIT	:= ./node_modules/.bin/nodeunit

include ./tools/mk/Makefile.defs

RELEASE_TARBALL	:= $(NAME)-pkg-$(STAMP).tar.bz2
TMPDIR          := /tmp/$(STAMP)



#
# Targets
#
.PHONY: all
all:
	npm install

.PHONY: test
test:
	$(NODEUNIT) test/*.test.js

.PHONY: release
release: all
	@echo "Building $(RELEASE_TARBALL)"
	mkdir -p $(TMPDIR)/$(NAME)
	cp -r \
		$(TOP)/bin \
		$(TOP)/build \
		$(TOP)/lib \
		$(TOP)/node_modules \
		$(TOP)/package.json \
		$(TOP)/README.md \
		$(TOP)/test \
		$(TMPDIR)/$(NAME)
	(cd $(TMPDIR) && $(TAR) -jcf $(TOP)/$(RELEASE_TARBALL) $(NAME))
	@rm -rf $(TMPDIR)

.PHONY: publish
publish: release
	@if [[ -z "$(BITS_DIR)" ]]; then \
		@echo "error: 'BITS_DIR' must be set for 'publish' target"; \
		exit 1; \
	fi
	mkdir -p $(BITS_DIR)/$(NAME)
	cp $(TOP)/$(RELEASE_TARBALL) $(BITS_DIR)/$(NAME)/$(RELEASE_TARBALL)

DISTCLEAN_FILES += node_modules


include ./tools/mk/Makefile.deps
include ./tools/mk/Makefile.targ
