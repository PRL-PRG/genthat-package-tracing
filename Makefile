SHELL = /bin/bash
TIMEOUT := 5h
RUN_DIR := run
LOG_DIR := logs
PACKAGE_FILE := packages.txt
JOBS_FILE := jobsfile.txt

SLOC := sloc.csv

packages := $(shell cat $(PACKAGE_FILE))
packages_dir := $(addprefix $(RUN_DIR)/, $(packages))
current_dir := $(strip $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
package_makefile := $(current_dir)/Makefile.package
rprofile := $(current_dir)/Rprofile.package

# parallel exit code is based on how many jobs has failed there will for sure be
# some so we just say keep going this will run make on each package with tasks
# given in as parameters
define parallel =
R_PROFILE_USER=$(rprofile) \
parallel \
  -j "$(JOBS_FILE)" \
  -a "$(PACKAGE_FILE)" \
  --shuf \
  --files \
  --bar \
  --tagstring "$@ - {}:" \
  --result "$(RUN_DIR)/{1}/{2}" \
  --joblog "$(LOG_DIR)/$@.log" \
  --timeout $(TIMEOUT) \
  make $(MFLAGS) -C "$(RUN_DIR)/{1}" -f $(package_makefile) "{2}" \
  :::
endef

.PHONY: bootstrap coverage-examples coverage-tests coverage-vignettes coverage-all coverage all clean distclean

all: bootstrap
	-$(parallel) coverage-tests coverage-all sloc

$(LOG_DIR):
	mkdir -p $(LOG_DIR)

$(packages_dir):
	mkdir -p $@

$(SLOC): bootstrap
	-$(parallel) sloc
	R_PROFILE_USER=$(rprofile) \
	Rscript -e 'merge_csv(list.files("$(RUN_DIR)", pattern="$(SLOC)", full.names=T, recursive=T), "$(SLOC)", cols(package="c", files="i", language="c", blank="i", comment="i", code="i"))'

bootstrap: $(LOG_DIR) $(packages_dir)

extract-code: bootstrap
	-$(parallel) $@

coverage-examples: bootstrap
	-$(parallel) $@

coverage-tests: bootstrap
	-$(parallel) $@

coverage-vignettes: bootstrap
	-$(parallel) $@

coverage-all: bootstrap
	-$(parallel) $@

coverage: bootstrap
	-$(parallel) coverage-examples coverage-tests coverage-vignettes coverage-all

genthat: bootstrap
	-$(parallel) $@

sloc: $(SLOC)

clean:
	@for dir in $(packages); do \
		$(MAKE) -C $(RUN_DIR)/$$dir -f $(package_makefile) clean; \
	done

distclean:
	-rm -fr $(LOG_DIR)
	-rm -fr $(RUN_DIR)
