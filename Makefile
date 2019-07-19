## shallow clone for speed

REBAR_GIT_CLONE_OPTIONS += --depth 1
export REBAR_GIT_CLONE_OPTIONS

TAG = $(shell git tag -l --points-at HEAD)

ifeq ($(EMQX_DEPS_DEFAULT_VSN),)
	ifneq ($(TAG),)
		EMQX_DEPS_DEFAULT_VSN ?= $(lastword 1, $(TAG))
	else
		EMQX_DEPS_DEFAULT_VSN ?= develop
	endif
endif

export EMQX_DEPS_DEFAULT_VSN

REBAR := rebar3

PROFILE ?= emqx
PROFILES := emqx emqx_pkg emqx_edge emqx_edge_pkg

CT_APPS := emqx_auth_mysql






.PHONY: default
default: $(PROFILE)

.PHONY: all
all: $(PROFILES)

.PHONY: distclean
distclean:
	@rm -rf _build
	@rm -f data/app.*.config data/vm.*.args rebar.lock
	@rm -rf _checkouts

.PHONY: $(PROFILES)
$(PROFILES:%=%):
ifneq ($(OS),Windows_NT)
	ln -snf _build/$(@)/lib ./_checkouts
endif
	$(REBAR) as $(@) release

.PHONY: $(PROFILES:%=build-%)
$(PROFILES:%=build-%):
	$(REBAR) as $(@:build-%=%) compile

.PHONY: deps-all
deps-all: $(PROFILES:%=deps-%)

.PHONY: $(PROFILES:%=deps-%)
$(PROFILES:%=deps-%):
	$(REBAR) as $(@:deps-%=%) get-deps

.PHONY: run $(PROFILES:%=run-%)
run: run-$(PROFILE)
$(PROFILES:%=run-%):
ifneq ($(OS),Windows_NT)
	@ln -snf _build/$(@:run-%=%)/lib ./_checkouts
endif
	$(REBAR) as $(@:run-%=%) run

.PHONY: clean $(PROFILES:%=clean-%)
clean: $(PROFILES:%=clean-%)
$(PROFILES:%=clean-%):
	@rm -rf _build/$(@:clean-%=%)
	@rm -rf _build/$(@:clean-%=%)+test

.PHONY: $(PROFILES:%=checkout-%)
$(PROFILES:%=checkout-%): build-$(PROFILE)
	ln -s -f _build/$(@:checkout-%=%)/lib ./_checkouts

# Checkout current profile
.PHONY: checkout
checkout:
	@ln -s -f _build/$(PROFILE)/lib ./_checkouts

# Run ct for an app in current profile
.PHONY: $(CT_APPS:%=ct-%)
ct: $(CT_APPS:%=ct-%)
$(CT_APPS:%=ct-%): checkout-$(PROFILE)
	$(REBAR) as $(PROFILE) ct --verbose --dir _checkouts/$(@:ct-%=%)/test --verbosity 50

