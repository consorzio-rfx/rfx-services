
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  ?= $(or $(JENKINS_DOCKER_IMAGE),jenkins/jenkins)
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml

STORE_DIR     ?= $(abs_builddir)
REROUTE_IP     = $(JENKINS_PUBLIC_IP)
REROUTE_PORTS  = $(JENKINS_PUBLIC_PORTS)

export abs_srcdir \
       abs_builddir \
	     DOCKER_IMAGE \
       STORE_DIR \
       REROUTE_IP \
       REROUTE_PORTS


LOCAL_DIRS = $(STORE_DIR)/jenkins_home

DIRECTORIES = $(LOCAL_DIRS)
$(STORE_DIR)/jenkins_home:
	@ docker run --name jenkins_home_copy \
      --rm -t --entrypoint="/bin/sh" \
      -v $@:/jhome $(DOCKER_IMAGE) \
      -c "cp -a /var/jenkins_home/* /jhome"

start-local: | $(LOCAL_DIRS)
stop-local:

all: start

