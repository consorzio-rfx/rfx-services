
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  ?= $(or $(TENSORFLOW_DOCKER_IMAGE),tensorflow/tensorflow)
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml
SWARM_NAME     = tensorflow
SERVICE        = tensorflow

STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(TENSORFLOW_PUBLIC_IP)
REROUTE_PORTS  = $(TENSORFLOW_PUBLIC_PORTS)

export abs_srcdir \
       abs_builddir \
	   DOCKER_IMAGE \
       STORE_DIR \
       REROUTE_IP \
       REROUTE_PORTS

all: start

start-local: | $(LOCAL_DIRS)
stop-local:


