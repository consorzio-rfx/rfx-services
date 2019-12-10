include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

SWARM_NAME = ansible
SERVICE = awxweb

# DOCKER_IMAGE  = ansible/centos7-ansible:stable
COMPOSER_FILE = docker-compose.yml


DIRECTORIES = $(STORE_DIR)/pgdocker

start-local: $(STORE_DIR)/pgdocker $(SSLCERT_FILES)
stop-local:

export REROUTE_IP =
export REROUTE_PORTS = 8052:8052

## ////////////////////////////////////////////////////////////////////////////////
## //  CERT SSL  //////////////////////////////////////////////////////////////////
## ////////////////////////////////////////////////////////////////////////////////

ssl_cert: ##@gitlab generate selfsigned certificate for ${HOSTNAME}
ssl_cert: $(SSLCERT_FILES)

export  SSLCERT_FILE_KEY \
        SSLCERT_FILE_CRT

# self sign certificates if they don't exist
SSLCERT_FILES    = $(SSLCERT_FILE_CRT) $(SSLCERT_FILE_KEY)
SSLCERT_FILE_CRT = $(STORE_DIR)/secret.crt
SSLCERT_FILE_KEY = $(STORE_DIR)/secret.key

${SSLCERT_FILES}:
	@ $(info generating cert for $@) \
	  . $(srcdir)/gencert.sh $(basename $(notdir $@)) $(dir $@)


