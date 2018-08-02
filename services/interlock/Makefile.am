include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

COMPOSER_FILE = $(srcdir)/docker-compose.yml

SWARM_HOST = tcp://localhost:3376

SERVICE_IP = 127.0.0.2

export SWARM_HOST \
       abs_srcdir \
       abs_builddir


DIRS = config \
       prova

$(DIRS):
	@ $(MKDIR_P) $@


start-local: | $(DIRS)
stop-local:

copy:
	@ cp $(COMPOSER_FILE) .; \
      cp $(abs_top_srcdir)/conf/services/service_reroute.sh .

all: start
