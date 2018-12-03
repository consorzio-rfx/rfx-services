
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

