include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk


# DIRECTORIES = config

DOCKER_IMAGE  = etherpad/etherpad:latest
COMPOSER_FILE = docker-compose.yml

start-local:
stop-local:


DOWNLOADS = etherpad-lite

etherpad-lite: ##@ehterpad download sources
etherpad_lite_URL = https://github.com/ether/etherpad-lite.git
etherpad_lite_BRANCH = master

DOCKER_TARGETS = test

test: DOCKER_CONTAINER_ID = fae2fda23cc7
test:
	echo ${SHELL}


