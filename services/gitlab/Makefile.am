include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

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

define SERVICE_EXPORTS = 
export GITLAB_DOCKER_IMAGE=$(GITLAB_DOCKER_IMAGE)
export GITLAB_EXTERNAL_URL=$(GITLAB_EXTERNAL_URL)
export HOSTNAME=$(HOSTNAME)
export SSLCERT_FILE_CRT=$(SSLCERT_FILE_CRT)
export SSLCERT_FILE_KEY=$(SSLCERT_FILE_KEY)
endef

## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

SSLCERT_FILE_CRT = $(or $(GITLAB_SSLCERT_FILE_CRT),$(abs_builddir)/selfsigned_$(HOSTNAME).crt)
SSLCERT_FILE_KEY = $(or $(GITLAB_SSLCERT_FILE_KEY),$(abs_builddir)/selfsigned_$(HOSTNAME).key)

ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
ssl_cert: ${SSLCERT_FILES}

DIRS = ${STORE_DIR}/config \
	   ${STORE_DIR}/logs   \
	   ${STORE_DIR}/data  

$(DIRS):
	@ $(MKDIR_P) $@

# self sign certificates if they don't exist
SSLCERT_FILES = $(SSLCERT_FILE_CRT) $(SSLCERT_FILE_KEY)
${SSLCERT_FILES}:  | $(DIRS)
	@ $(info generating cert for $@) \
	  . $(srcdir)/gencert.sh $(basename $(notdir $@)) $(dir $@)


## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

# COMPOSER_FILE = $(or $(GITLAB_COMPOSER_FILE),$(srcdir)/docker-compose.yml)
COMPOSER_FILE = $(srcdir)/docker-compose.yml

start-local: ${SSLCERT_FILE} | $(DIRS)
stop-local:

## ////////////////////////////////////////////////////////////////////////////////
## //  INSTALL  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

$(INSTALL_TARGETS): SSLCERT_FILE_CRT := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_CRT))
$(INSTALL_TARGETS): SSLCERT_FILE_KEY := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_KEY))

copy-service-data:
	- cp -a $(SSLCERT_FILES) $(install_servicedir)
	- cp -a $(DIRS) $(install_storedir)

install-data-local: ${SSLCERT_FILES}
	@ $(MAKE) copy-service-data

SERVICE_DATA = RFX_code.png

## ////////////////////////////////////////////////////////////////////////////////
## //  CLEAN  /////////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

CLEANFILES = ${STORE_DIR}/config/ssl/* selfsigned_*



## POSSIBLE APPROACH TO MAKE AUTOMATIC
#
# SERVICE_EXPORTS =
# COPY_SERVICEDATA =
#
# define add_service_file =
# $(INSTALL_TARGETS): $1 := $(SERVICE_DIR)/$(notdir $(SSLCERT_FILE_CRT))
# define SERVICE_EXPORTS += 
# export $1=$$($1)
# endef
# COPY_SERVICEDATA += $1
# endef
#
# $(eval $(call $(add_service_export),$(SSLCERT_FILE_CRT)))





