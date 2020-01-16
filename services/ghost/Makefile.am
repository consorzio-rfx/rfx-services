include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

COMPOSER_FILE = docker-compose.yml

REROUTE_IP     = 127.0.0.1
REROUTE_PORTS  = 80:80 443:443 2368:2368
HOSTNAME  = localhost
GHOST_URL = http://localhost

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
