include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  ?= $(or $(SPARK_DOCKER_IMAGE),$(VENDOR)/$(SERVICE):$(VERSION))
EXTERNAL_IP   ?= $(or $(SPARK_EXTERNAL_IP),localhost)
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml

export abs_srcdir \
       abs_builddir \
	   DOCKER_IMAGE \
	   EXTERNAL_IP

build:
	@ docker build -t $(DOCKER_IMAGE) $(srcdir)

all: start

start-local: | $(LOCAL_DIRS)
stop-local:


