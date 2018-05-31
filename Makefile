TIMEOUT := 3h 
RUNDIR := run
LOGDIR := logs
PACKAGE_FILE := packages.txt
JOBS_FILE := jobsfile.txt
PACKAGES := $(shell cat $(PACKAGE_FILE))

define parallel =
parallel \
  -j jobsfile.txt \
  -a "$(PACKAGE_FILE)" \
  --shuf \
  --files \
  --bar \
  --result "$(RUNDIR)/{}/$@" \
  --joblog "$(LOGDIR)/$@.log" \
  --timeout $(TIMEOUT) \
  make -C "$(RUNDIR)/{1}" $@
endef

.PHONY: bootstrap coverage-tests coverage-all all clean distclean

all: bootstrap coverage-tests coverage-all

bootstrap:
	-mkdir -p $(LOGDIR)
	-mkdir -p $(RUNDIR)
	@for pkg in $(PACKAGES); do \
		echo $$pkg; \
		[ -d $(RUNDIR)/$$pkg ] || mkdir $(RUNDIR)/$$pkg; \
		[ -L $(RUNDIR)/$$pkg/Makefile ] || ln -s ../../Makefile.package $(RUNDIR)/$$pkg/Makefile; \
		[ -L $(RUNDIR)/$$pkg/.Rprofile ] || ln -s ../../Rprofile.package $(RUNDIR)/$$pkg/.Rprofile; \
	done

coverage-tests:
	$(parallel)
coverage-all:
	$(parallel)
genthat:
	$(parallel)

clean:
	@for dir in $(PACKAGES); do \
		$(MAKE) -C $(RUNDIR)/$$dir clean; \
	done

distclean:
	-rm -fr $(LOGDIR)
	-rm -fr $(RUNDIR)
