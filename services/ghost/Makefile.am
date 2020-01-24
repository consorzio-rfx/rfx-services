include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

COMPOSER_FILE = docker-compose.yml

REROUTE_IP     = 127.0.0.1
REROUTE_PORTS  = 80:80 443:443 2368:2368
HOSTNAME  = ghost.igi.cnr.it
GHOST_URL = http://ghost.igi.cnr.it

export REROUTE_IP \
       REROUTE_PORTS \
       GHOST_URL \
       HOSTNAME \
       SSLCERT_FILE_CRT \
       SSLCERT_FILE_KEY 


DIRS =  ${STORE_DIR}/nginx/etc/ \
        ${STORE_DIR}/nginx/etc/letsencrypt/ \
        ${STORE_DIR}/nginx/html \
  	     ${STORE_DIR}/ghost_mysql \
  	     ${STORE_DIR}/ghost_content
        

DIRECTORIES = $(DIRS)

start-local: ${SSLCERT_FILE} | $(DIRS)
stop-local:


NGINX_DOCKER_IMAGE = nginx:latest

$(SERVICE_DIR)/nginx/etc:
	@ $(MKDIR_P) $@;
	@ docker run --name docker_directory_copy \
	    --rm -t --entrypoint="/bin/sh" \
	    -v $@:/dst $(NGINX_DOCKER_IMAGE) \
	    -c "cp -a /etc/nginx/* /dst"



service-dirs: $(SERVICE_DIR)/nginx/etc




# DOCKER_TARGETS = cb-init
# cb-init: DOCKER_CONTAINER = certbot
# cb-init: DOCKER_IMAGE = certbot-nginx:latest
# cb-init: DOCKER_URL = $(srcdir)/certbot
# cb-init: ##@certbot init image
# 	@;




## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

ssl_cert: ##@ssl generate selfsigned certificate for ${HOSTNAME}
ssl_cert: $(SSLCERT_FILES)

# self sign certificates if they don't exist
SSLCERT_FILES    = $(SSLCERT_FILE_CRT) $(SSLCERT_FILE_KEY)
SSLCERT_FILE_CRT = $(or $(GITLAB_SSLCERT_FILE_CRT),$(abs_builddir)/selfsigned_$(HOSTNAME).crt)
SSLCERT_FILE_KEY = $(or $(GITLAB_SSLCERT_FILE_KEY),$(abs_builddir)/selfsigned_$(HOSTNAME).key)

${SSLCERT_FILES}:
	@ $(info generating cert for $@) \
	  . $(srcdir)/gencert.sh $(basename $(notdir $@)) $(dir $@)


## ////////////////////////////////////////////////////////////////////////////////
## //  INSTALL  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

define SERVICE_EXPORTS = 
export HOSTNAME=$(HOSTNAME)
export SSLCERT_FILE_CRT=$(SSLCERT_FILE_CRT)
export SSLCERT_FILE_KEY=$(SSLCERT_FILE_KEY)
endef

$(INSTALL_TARGETS): SSLCERT_FILE_CRT := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_CRT))
$(INSTALL_TARGETS): SSLCERT_FILE_KEY := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_KEY))

SERVICE_DATA = $(DIRS) \
               $(SSLCERT_FILES)

## ////////////////////////////////////////////////////////////////////////////////
## //  CLEAN  /////////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

CLEANFILES = selfsigned_* 
