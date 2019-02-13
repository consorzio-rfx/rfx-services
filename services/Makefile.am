include $(top_srcdir)/Common.mk
SUBDIRS = $(SERVICE_MODULES)

.PHONY: start stop list

start:   ##@services Start all enabled services
stop:    ##@services Stop all enabled services
start stop:
	@ $(info starting services ... "$(SERVICE_MODULES)") \
      for i in $(SERVICE_MODULES); do \
       $(MAKE) -C $$i $@; \
      done

list: ##@services get a list of enabled services
list:
	@ echo; \
      echo "Eanbled services: $(SERVICE_MODULES)"; \
      echo;

##     .####.##....##..######..########....###....##.......##......
##     ..##..###...##.##....##....##......##.##...##.......##......
##     ..##..####..##.##..........##.....##...##..##.......##......
##     ..##..##.##.##..######.....##....##.....##.##.......##......
##     ..##..##..####.......##....##....#########.##.......##......
##     ..##..##...###.##....##....##....##.....##.##.......##......
##     .####.##....##..######.....##....##.....##.########.########

# $prefix/share/rfx-services
service_rootdir = $(datadir)/rfx-services
service_root_SCRIPTS = $(srcdir)/service_reroute.sh \
                       $(srcdir)/docker_utils.sh

service_root_DATA = $(srcdir)/rfx-services.target
install-data-hook:
	- systemctl link -f $(service_rootdir)/rfx-services.target


