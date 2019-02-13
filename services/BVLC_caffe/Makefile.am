include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = bvlc/caffe:cpu
COMPOSER_FILE = $(srcdir)/docker-compose.yml

DIRECTORIES = notebooks
install-data-local: | notebooks
	- cp -a notebooks $(STORE_DIR)

start-local: | notebooks
stop-local:


