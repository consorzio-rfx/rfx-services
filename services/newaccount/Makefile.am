
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

COMPOSER_FILE  = $(srcdir)/docker-composer.yml
SWARM_NAME     = newaccount
SERVICE        = newaccount

HTML_DIR = $(srcdir)/newaccount
REROUTE_IP     = 192.168.60.156
REROUTE_PORTS  = 80:80

export 	HTML_DIR \
	REROUTE_IP \
	REROUTE_PORTS

start-local:
stop-local:

#all: start

all: build

build: Dockerfile
	@ $(info create docker image) \
	  cp $(srcdir)/$< $(builddir)/$<;
	  docker build -t consorziorfx/php-ldap:latest .

