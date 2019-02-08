include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

##
##  NOT WORKING YET
##
COMPOSER_FILE = $(srcdir)/docker-compose.yml

DOCKER_TARGETS = btsync-%
btsync-%: DOCKER_CONTAINER = btsync
btsync-%: DOCKER_IMAGE = rigoni/btsync:latest

btsync-init: DOCKER_DOCKERFILE = $(srcdir)/Dockerfile
btsync-init: DOCKER_URL = $(srcdir)
btsync-init:
	@ echo $@;

btsync-clean: docker-clean
clean-local: btsync-clean

rslsync.sample:
	@ rslsync --dump-sample-config > $(srcdir)/$@

SERVICE_DATA = rslsync.sample
