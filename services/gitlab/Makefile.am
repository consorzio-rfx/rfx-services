include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

COMPOSER_FILE = $(or $(GITLAB_COMPOSER_FILE),$(srcdir)/docker-compose.yml)

REROUTE_IP     = $(GITLAB_PUBLIC_IP)
REROUTE_PORTS  = $(GITLAB_PUBLIC_PORTS)
GITLAB_EXTERNAL_URL  ?= https://localhost

export HOSTNAME   \
	   GITLAB_EXTERNAL_URL \
       GITLAB_DOCKER_IMAGE \
       REROUTE_IP \
       REROUTE_PORTS \
       SSLCERT_FILE_CRT \
       SSLCERT_FILE_KEY

export gitlab_email_from = donotreply@igi.cnr.it

DIRS = ${STORE_DIR}/config \
  	   ${STORE_DIR}/logs   \
  	   ${STORE_DIR}/data  

DIRECTORIES = $(DIRS)

start-local: ${SSLCERT_FILE} | $(DIRS)
stop-local:

gitlab.rb: gitlab.rb.in
	@ $(call __ax_pl_envsubst2,$<,$@);


## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
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
export GITLAB_DOCKER_IMAGE=$(GITLAB_DOCKER_IMAGE)
export GITLAB_EXTERNAL_URL=$(GITLAB_EXTERNAL_URL)
export HOSTNAME=$(HOSTNAME)
export SSLCERT_FILE_CRT=$(SSLCERT_FILE_CRT)
export SSLCERT_FILE_KEY=$(SSLCERT_FILE_KEY)
endef

$(INSTALL_TARGETS): SSLCERT_FILE_CRT := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_CRT))
$(INSTALL_TARGETS): SSLCERT_FILE_KEY := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_KEY))

SERVICE_DATA = $(DIRS) \
               $(SSLCERT_FILES) \
               RFX_code.png \
               gitlab.rb

## ////////////////////////////////////////////////////////////////////////////////
## //  CLEAN  /////////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

CLEANFILES = selfsigned_* 



