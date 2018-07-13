
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
       SHARELATEX_DOCKER_IMAGE \
       SSLCERT_FILE_CRT \
       SSLCERT_FILE_KEY

export SHARELATEX_SITE_URL \
       SHARELATEX_EMAIL_FROM_ADDRESS \
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
	@ docker run --name sharelatex_texlive_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/texlive $(SHARELATEX_DOCKER_IMAGE) \
      -c "cp -a /usr/local/texlive/* /texlive"

$(STORE_DIR)/sharelatex_templates:
	@ docker run --name sharelatex_templates_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/templates $(SHARELATEX_DOCKER_IMAGE) \
      -c "cp -a /var/www/sharelatex/web/app/templates/* /templates"

$(STORE_DIR)/sharelatex_web:
	@ docker run --name sharelatex_templates_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/web $(SHARELATEX_DOCKER_IMAGE) \
      -c "cp -a /var/www/sharelatex/web/* /web"

LOCAL_DIRS = $(STORE_DIR)/sharelatex_texlive \
             $(STORE_DIR)/sharelatex_templates \
             $(STORE_DIR)/sharelatex_web

dirs: $(DIRS)
local_dirs: $(LOCAL_DIRS)


## CERTIFICATES

SSLCERT_FILE_CRT = $(or $(SHARELATEX_SSLCERT_FILE_CRT),$(abs_builddir)/selfsigned_$(HOSTNAME).crt)
SSLCERT_FILE_KEY = $(or $(SHARELATEX_SSLCERT_FILE_KEY),$(abs_builddir)/selfsigned_$(HOSTNAME).key)

ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
ssl_cert: ${SSLCERT_FILES}

# self sign certificates if they don't exist
SSLCERT_FILES = $(SSLCERT_FILE_CRT) $(SSLCERT_FILE_KEY)
${SSLCERT_FILES}:  | $(DIRS)
	@ $(info generating cert for $@) \
	  . $(srcdir)/gencert.sh $(basename $(notdir $@)) $(dir $@)




start-local: | ${SSLCERT_FILES} $(DIRS) $(LOCAL_DIRS)
	@ $(info "after first deploy navigate to http://${REROUTE_IP}/launchpad to setup the initial credentials") \
      $(info "To exdend texlive to full scheme perform the following target once: make texlive-full")

stop-local:

texlive-full: ##@sharelatex install scheme-full
texlive-full: $(STORE_DIR)/sharelatex_texlive
	docker run --name sharelatex_texlive_upgrade \
      --rm -t --entrypoint="/bin/sh" \
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
	@


# RUN cd /var/www/sharelatex; \
# 	npm install; \
# 	grunt install; \
# 	bash -c 'source ./bin/install-services'; \
# 	cd web; \
# 	npm install; \
# 	npm install bcrypt; \
# 	cd modules; \
# 	git clone https://github.com/sharelatex/launchpad-web-module.git launchpad; \
# 	grunt compile;






