
include $(top_srcdir)/services/docker_services.mk


STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(GITLAB_PUBLIC_IP)
REROUTE_PORTS  = $(GITLAB_PUBLIC_PORTS)
GITLAB_EXTERNAL_URL ?= http://localhost

export HOSTNAME   \
	   GITLAB_EXTERNAL_URL \
       GITLAB_DOCKER_IMAGE \
	   STORE_DIR  \
       REROUTE_IP \
       REROUTE_PORTS

## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

SSLCERT_FILE = ${STORE_DIR}/config/ssl/$(HOSTNAME).crt
ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
ssl_cert: ${SSLCERT_FILE}

DIRS = ${STORE_DIR}/config \
	   ${STORE_DIR}/logs \
	   ${STORE_DIR}/data \
	   ${STORE_DIR}/config/ssl

$(DIRS):
	@ $(MKDIR_P) $@

# self signed certificate
${SSLCERT_FILE}: $(srcdir)/gencert.sh | $(DIRS)
	@ $(info generating cert for ${HOSTNAME}) \
	  . $< ${HOSTNAME} $(dir $@)

CLEANFILES   = ${STORE_DIR}/config/ssl/*


## ////////////////////////////////////////////////////////////////////////////////
## //  SERVICE  ///////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

COMPOSER_FILE = $(or $(GITLAB_COMPOSER_FILE),$(srcdir)/docker-composer.yml)

SWARM_NAME    = gitlab
SERVICE       = gitlab

start-local: ${SSLCERT_FILE} | $(DIRS)
stop-local:


