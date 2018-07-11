
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

SHARELATEX_DOCKER_IMAGE ?= consorziorfx/sharelatex:latest
COMPOSER_FILE  = $(srcdir)/docker-composer.yml
SWARM_NAME     = sharelatex
SERVICE        = sharelatex

STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(SHARELATEX_PUBLIC_IP)
REROUTE_PORTS  = $(SHARELATEX_PUBLIC_PORTS)


export abs_srcdir \
       abs_builddir \
       STORE_DIR \
       REROUTE_IP \
       REROUTE_PORTS \
       SHARELATEX_DOCKER_IMAGE

export SHARELATEX_EMAIL_FROM_ADDRESS \
       SHARELATEX_EMAIL_SMTP_HOST \
       SHARELATEX_EMAIL_SMTP_PORT \
       SHARELATEX_EMAIL_SMTP_SECURE \
       SHARELATEX_EMAIL_SMTP_USER \
       SHARELATEX_EMAIL_SMTP_PASS \
       SHARELATEX_EMAIL_SMTP_TLS_REJECT_UNAUTH \
       SHARELATEX_EMAIL_SMTP_IGNORE_TLS \
       SHARELATEX_CUSTOM_EMAIL_FOOTER

all: start


DIRS = $(addprefix $(STORE_DIR)/, \
         mongo_data \
         redis_data \
         sharelatex_data \
         sharelatex_logs \
         sharelatex_logs/sharelatex \
         sharelatex_logs/nginx \
        )

$(DIRS):
	@ $(MKDIR_P) $@

$(STORE_DIR)/sharelatex_texlive:
	@ docker run --rm -t --entrypoint="/bin/sh" \
      -v $@:/texlive $(SHARELATEX_DOCKER_IMAGE) \
      -c "cp -a /usr/local/texlive/* /texlive"

$(STORE_DIR)/sharelatex_templates:
	@ docker run --rm -t --entrypoint="/bin/sh" \
      -v $@:/templates $(SHARELATEX_DOCKER_IMAGE) \
      -c "cp -a /var/www/sharelatex/web/app/templates/* /templates"

start-local: | $(DIRS) $(STORE_DIR)/sharelatex_texlive $(STORE_DIR)/sharelatex_templates
	@ $(info "after first deploy navigate to http://${REROUTE_IP}/launchpad to setup the initial credentials") \
      $(info "To exdend texlive to full scheme perform the following target once: make texlive-full")

stop-local:

texlive-full: ##@sharelatex install scheme-full
texlive-full: $(STORE_DIR)/sharelatex_texlive
	docker run --rm -t --entrypoint="/bin/sh" \
      -v $<:/usr/local/texlive \
      $(SHARELATEX_DOCKER_IMAGE) \
      -c "tlmgr install scheme-full"


## ////////////////////////////////////////////////////////////////////////////////
## //  DOCKER IMAGE BUILD  ////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////


DOWNLOADS = sharelatex_docker_image sharelatex_src
sharelatex_docker_image_URL = https://github.com/andrearigoni/sharelatex-docker-image.git
sharelatex_docker_image_BRANCH = master
sharelatex_src_URL = https://github.com/andrearigoni/sharelatex.git
sharelatex_src_BRANCH = master

sl-docker: ##@sharelatex build docker image
sl-docker: export SHARELATEX_TAG=$(SHARELATEX_DOCKER_IMAGE)
sl-docker: sharelatex_docker_image
	@ $(MAKE) -C sharelatex_docker_image

sl-build: ##@sharelatex build local sharelatex sources
sl-build: sharelatex_src
	@ $(error "Not supported yet")
