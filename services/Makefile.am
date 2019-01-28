
include $(top_srcdir)/Common.mk

.PHONY: $(SERVICE_MODULES)
$(SERVICE_MODULES):
	@ $(info ,-------------------------------------------------- ) \
      $(info | STARTING: $@ ) \
      $(info | ) \
      $(MAKE) -C $@ $(ACTION)


.PHONY: start stop list

start: ##@services Start all enabled services
stop: ##@services Stop all enabled services
start stop:
	@ $(info starting services ... "$(SERVICE_MODULES)") \
      for i in $(SERVICE_MODULES); do \
       $(MAKE) $$i ACTION=$@; \
      done

list: ##@services get a list of enabled services
list:
	@ echo; \
      echo "Eanbled services: $(SERVICE_MODULES)"; \
      echo;

all: start

## write enabled sevices in config file
$(file > rfx-services.enabled, $(SERVICE_MODULES))
sysconf_DATA = $(builddir)/rfx-services.enabled

## TODO: move this in confiugre
libexecdir = $(datadir)/rfx-services/

# $prefix/share/rfx-services
libexec_SCRIPTS = $(srcdir)/service_reroute.sh

# $prefix/etc/init.d
init_ddir = $(sysconfdir)/init.d
init_d_SCRIPTS = $(builddir)/rfx-services.sh

systemddir = $(sysconfdir)/systemd/system/
systemd_DATA = $(builddir)/rfx-services.service