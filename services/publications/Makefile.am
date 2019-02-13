
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

COMPOSER_FILE  = $(srcdir)/docker-composer.yml
SWARM_NAME     = publications
SERVICE        = publications

HTML_DIR = $(abs_srcdir)/publications
REROUTE_IP     = 192.168.60.157
REROUTE_PORTS  = 80:80

export 	HTML_DIR \
	abs_srcdir \
	REROUTE_IP \
	REROUTE_PORTS

start-local:
stop-local:

#all: start

all: build

build: Dockerfile
	@ $(info create docker image) \
	  cp $(srcdir)/$(notdir $<) $(builddir)/$(notdir $<);
	  docker build -t consorziorfx/php-ldap:5.6 .

#shell:
#	@ /bin/bash
