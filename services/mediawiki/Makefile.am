include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = consorziorfx/mediawiki:git
COMPOSER_FILE = $(srcdir)/docker-composer.yml

## define here exported variables that must appear in service.conf
define SERVICE_EXPORTS = 
#
# OTHER CUSTOM VARIABLES EXPORTED FROM MAKEFILE #
export HOSTNAME=$(HOSTNAME)
#
endef


html:
	@ mkdir -p $@; \
      docker run --name mediawiki_html_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/html $(DOCKER_IMAGE) \
      -c "cp -a /var/www/html/* /html"

start-local: html
stop-local:

SERVICE_DATA = LocalSettings.php \
               my_wiki.db

install-data-local: $(STORE_DIR)/html
	- cp -a $(srcdir)/git-mediawiki $(SERVICE_DIR)
	- cp -a html $(STORE_DIR)

##
## BUILD IMAGE FOR MEDIAWIKI
##

DOCKER_TARGETS = image-%
image-%: DOCKER_CONTAINER = mediawiki
image-%: DOCKER_IMAGE = consorziorfx/mediawiki:git  ## not actually needed in this example

image-init: DOCKER_DOCKERFILE = $(srcdir)/Dockerfile
image-init: DOCKER_URL = $(srcdir)
image-init: 
	@:;

image-push: DOCKER_REGISTRY = localhost:5000
image-push: image-init docker-start docker-push
image-pushhub: image-init docker-push
image-clean: docker-clean


all: image-push
clean-local: image-clean

