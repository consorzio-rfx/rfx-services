include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk


COMPOSER_FILE = docker-compose.yml

REROUTE_IP     = 127.0.0.1
REROUTE_PORTS  = 8888:8888 8080:8080 8081:8081 7077:7077

export abs_srcdir \
       abs_builddir \
	   EXTERNAL_IP

#	   DOCKER_IMAGE

LOCAL_DIRS = 	${SERVICE_DIR}/.jupyter \
				${STORE_DIR}/work


DIRECTORIES = $(LOCAL_DIRS)


# $(DIRECTORIES):
# 	@ $(MKDIR_P) $@
# build:
# 	@ docker build -t $(DOCKER_IMAGE) $(srcdir)


DOWNLOADS = spark-build
spark-build: ##@spark download docker build support
spark_build_URL = https://github.com/AndreaRigoni/docker-spark.git
spark_build_BRANCH = master


all:

start-local: | $(LOCAL_DIRS)
stop-local:


