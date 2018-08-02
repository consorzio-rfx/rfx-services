
include $(top_srcdir)/services/docker_services.mk


STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(GITLAB_PUBLIC_IP)
REROUTE_PORTS  = $(GITLAB_PUBLIC_PORTS)
GITLAB_EXTERNAL_URL  ?= https://localhost

export HOSTNAME   \
	   GITLAB_EXTERNAL_URL \
       GITLAB_DOCKER_IMAGE \
	   STORE_DIR  \
       REROUTE_IP \
       REROUTE_PORTS \
       SSLCERT_FILE_CRT \
       SSLCERT_FILE_KEY


## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////


SSLCERT_FILE_CRT = $(or $(GITLAB_SSLCERT_FILE_CRT),$(abs_builddir)/selfsigned_$(HOSTNAME).crt)
SSLCERT_FILE_KEY = $(or $(GITLAB_SSLCERT_FILE_KEY),$(abs_builddir)/selfsigned_$(HOSTNAME).key)


ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
ssl_cert: ${SSLCERT_FILES}

DIRS = ${STORE_DIR}/config \
	   ${STORE_DIR}/logs \
	   ${STORE_DIR}/data \
	   ${STORE_DIR}/config/ssl

$(DIRS):
	@ $(MKDIR_P) $@

# self sign certificates if they don't exist
SSLCERT_FILES = $(SSLCERT_FILE_CRT) $(SSLCERT_FILE_KEY)
${SSLCERT_FILES}:  | $(DIRS)
	@ $(info generating cert for $@) \
	  . $(srcdir)/gencert.sh $(basename $(notdir $@)) $(dir $@)

CLEANFILES   = ${STORE_DIR}/config/ssl/*

## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

COMPOSER_FILE = $(or $(GITLAB_COMPOSER_FILE),$(srcdir)/docker-compose.yml)


start-local: ${SSLCERT_FILE} | $(DIRS)
stop-local:


