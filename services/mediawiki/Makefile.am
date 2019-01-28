include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = mediawiki:gitmw
COMPOSER_FILE = $(srcdir)/docker-composer.yml
STORE_DIR     = $(abs_builddir)

export abs_srcdir \
       abs_builddir \
       STORE_DIR \
       REROUTE_IP \
       REROUTE_PORTS \
       DOCKER_IMAGE \
       COMPOSER_FILE 

$(STORE_DIR)/html:
	@ mkdir -p $@; \
      docker run --name mediawiki_html_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/html $(DOCKER_IMAGE) \
      -c "cp -a /var/www/html/* /html"





start-local: $(STORE_DIR)/html
stop-local:

build: Dockerfile
	@ cp $< .; \
	  docker build -f $< -t $(DOCKER_IMAGE) .






