include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  ?= $(or $(SPARK_DOCKER_IMAGE),$(VENDOR)/$(SERVICE):$(VERSION))
EXTERNAL_IP   ?= $(or $(SPARK_EXTERNAL_IP),$(HOSTNAME))
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml

export abs_srcdir \
       abs_builddir \
	   DOCKER_IMAGE \
	   EXTERNAL_IP

LOCAL_DIRS = ${STORE_DIR}/redis_data

DIRECTORIES += $(LOCAL_DIRS)

build:
	@ docker build -t $(DOCKER_IMAGE) $(srcdir)

all: start

start-local: | $(LOCAL_DIRS)
stop-local:


