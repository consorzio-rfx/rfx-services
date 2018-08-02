
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk



DOCKER_IMAGE  ?= $(or $(BVLC_CAFFE_DOCKER_IMAGE),bvlc/caffe:cpu)
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml


STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(BVLC_CAFFE_PUBLIC_IP)
REROUTE_PORTS  = $(BVLC_CAFFE_PUBLIC_PORTS)

export abs_srcdir \
       abs_builddir \
	   DOCKER_IMAGE \
       STORE_DIR \
       REROUTE_IP \
       REROUTE_PORTS

all: start

start-local: | $(LOCAL_DIRS)
stop-local:


