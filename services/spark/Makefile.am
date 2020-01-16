include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk


COMPOSER_FILE = docker-compose.yml

REROUTE_IP     = 127.0.0.1
REROUTE_PORTS  = 8888:8888 8080:8080 8081:8081 7077:7077

export abs_srcdir \
       abs_builddir \
	   EXTERNAL_IP

#	   DOCKER_IMAGE

LOCAL_DIRS = ${STORE_DIR}/redis_data

DIRECTORIES = $(LOCAL_DIRS)

$(DIRECTORIES):
	@ $(MKDIR_P) $@

# build:
# 	@ docker build -t $(DOCKER_IMAGE) $(srcdir)

all:

start-local: | $(LOCAL_DIRS)
stop-local:


