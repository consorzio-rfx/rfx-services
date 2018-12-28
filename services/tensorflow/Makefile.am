
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  ?= $(or $(TENSORFLOW_DOCKER_IMAGE),tensorflow/tensorflow)
COMPOSER_FILE ?= $(srcdir)/docker-compose.yml

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



##    .########.########....########..##.....##.####.##.......########.
##    ....##....##..........##.....##.##.....##..##..##.......##.....##
##    ....##....##..........##.....##.##.....##..##..##.......##.....##
##    ....##....######......########..##.....##..##..##.......##.....##
##    ....##....##..........##.....##.##.....##..##..##.......##.....##
##    ....##....##..........##.....##.##.....##..##..##.......##.....##
##    ....##....##..........########...#######..####.########.########.


BAZEL_CACHEDIR = /tmp/bazel_cache
DIRECTORIES  = $(BAZEL_CACHEDIR)
LOCAL_DIRS   = $(BAZEL_CACHEDIR)

export BAZEL_CACHEDIR
export DOCKER_CONTAINER
export DOCKER_IMAGE
export DOCKER_NETWORKS

DSHELL = $(top_srcdir)/conf/dk.sh
$(DOCKER_TARGETS): SHELL = $(DSHELL)

docker-%:
	@ $(info [docker] $*)
	@ . $(DSHELL) $*


DOWNLOADS = tensorflow
tensorflow: ##@ext tensorflow
tensorflow_URL    = https://github.com/tensorflow/tensorflow.git
tensorflow_BRANCH = master

# python packages needed for tf
PYTHON_PACKAGES = pip six numpy wheel mock
tf_DOCKER_IMAGE = tensorflow/tensorflow:nightly-devel-py3

define _install_new_git =
 apt-get update; \
 apt install -y git wget;
endef


DOCKER_TARGETS = tf-init
tf-init: ##@tf build process
tf-init: DOCKER_IMAGE = $(tf_DOCKER_IMAGE)
tf-init: DOCKER_CONTAINER = tf-build
tf-init: | tensorflow pip-install
	@ cd tensorflow;

tensorflow/.tf_configure.bazelrc: | tf-init
	@ cd tensorflow; ./configure

tf-configure: tensorflow/.tf_configure.bazelrc

tf-build: tf-configure | tf-init
	@ cd tensorflow; \
      bazel build --remote_http_cache=http://localhost:8980 \
       --spawn_strategy=standalone \
       --config=opt //tensorflow/tools/pip_package:build_pip_package

tf-shell: ##@tf enter container shell
tf-shell: | tf-init
	@ /bin/bash



##       ..######.....###.....######..##.....##.########
##       .##....##...##.##...##....##.##.....##.##......
##       .##........##...##..##.......##.....##.##......
##       .##.......##.....##.##.......#########.######..
##       .##.......#########.##.......##.....##.##......
##       .##....##.##.....##.##....##.##.....##.##......
##       ..######..##.....##..######..##.....##.########

## NOT WORKING YET ##
##
tf-cache: ##@tf build tensorflow starting docker swarm for that
tf-cache: SWARM_NAME = tf-cache
tf-cache: COMPOSER_FILE = $(srcdir)/docker-compose_bazel.yml
tf-cache: DOCKER_IMAGE  = buchgr/bazel-remote-cache
tf-cache: $(BAZEL_CACHEDIR) start



##      .########.....###....########.########.##...........########....###....########..##.....##
##      .##.....##...##.##........##..##.......##...........##.........##.##...##.....##.###...###
##      .##.....##..##...##......##...##.......##...........##........##...##..##.....##.####.####
##      .########..##.....##....##....######...##...........######...##.....##.########..##.###.##
##      .##.....##.#########...##.....##.......##...........##.......#########.##...##...##.....##
##      .##.....##.##.....##..##......##.......##...........##.......##.....##.##....##..##.....##
##      .########..##.....##.########.########.########.....##.......##.....##.##.....##.##.....##

DOWNLOADS += build-farm

build_farm_URL = https://github.com/bazelbuild/bazel-buildfarm.git
build_farm_BRANCH = master

build-farm-server: ##@bazel build farm server
build-farm-server: | build-farm tf-init
	@ cd build-farm; \
	  bazel build //src/main/java/build/buildfarm:buildfarm-server; \
      bazel-bin/src/main/java/build/buildfarm/buildfarm-server  examples/server.config.example
      

build-farm-worker: ##@bazel build farm worker
build-farm-worker: | build-farm tf-init
	@ cd build-farm; \
	  bazel build //src/main/java/build/buildfarm:buildfarm-worker; \
      bazel-bin/src/main/java/build/buildfarm/buildfarm-worker  examples/worker.config.example


DOCKER_TARGETS += dk-build-farm-worker
dk-build-farm-worker: ##@bazel build farm dockerized worker (swarm deploy)
dk-build-farm-worker: DOCKER_CONTAINER = bbf-worker
dk-build-farm-worker: DOCKER_IMAGE = insready/bazel:latest
dk-build-farm-worker: | build-farm
	@ cd build-farm; \
	  bazel build //src/main/java/build/buildfarm:buildfarm-worker; \
      bazel-bin/src/main/java/build/buildfarm/buildfarm-worker  examples/worker.config.example


## NOT WORKING YET ##
##
bbf-worker: ##@bazel start swarm workers
bbf-worker: SWARM_NAME = bbf-worker
bbf-worker: COMPOSER_FILE = $(srcdir)/docker-compose_bbf.yml
bbf-worker: start



# Bazel Itself
# To have bazel use the bazel buildfarm configured using the example configs provided in the examples directory, you could configure your .bazelrc as follows:
# 
# $ cat .bazelrc
# build --spawn_strategy=remote --genrule_strategy=remote --strategy=Javac=remote --strategy=Closure=remote --remote_executor=localhost:8980
# Then run your build as you would normally do.


## WARNING ...
##
## this method seems to fail to build Tensorflow because of dependency problems.
## could a shared remote cache service solve this issue? 





# ##      .########.....###....########.########.##...........########.....###....########..##....##
# ##      .##.....##...##.##........##..##.......##...........##.....##...##.##...##.....##.###...##
# ##      .##.....##..##...##......##...##.......##...........##.....##..##...##..##.....##.####..##
# ##      .########..##.....##....##....######...##...........########..##.....##.########..##.##.##
# ##      .##.....##.#########...##.....##.......##...........##.....##.#########.##...##...##..####
# ##      .##.....##.##.....##..##......##.......##...........##.....##.##.....##.##....##..##...###
# ##      .########..##.....##.########.########.########.....########..##.....##.##.....##.##....##



#########################################

##                   ##
##   DISCONTINUED    ##
##                   ##

# not used anymore .... we prefer to have bazel container to build buildbarn
#
# DOWNLOADS += buildbarn
# buildbarn_URL = https://github.com/EdSchouten/bazel-buildbarn.git
# buildbarn_BRANCH = master

# buildbarn-browser: ##@buildbarn build browser
# buildbarn-frontend: ##@buildbarn build frontend
# buildbarn-scheduler: ##@buildbarn build scheduler
# buildbarn-worker: ##@buildbarn build worker

# .PHONY: buildbarn-all
# buildbarn-all: ##@buildbarn build all needed targets
# buildbarn-all: buildbarn-browser buildbarn-frontend buildbarn-scheduler buildbarn-worker

# buildbarn-%: | buildbarn
# 	@ cd buildbarn; \
#       bazel build //cmd/bbb_$*:bbb_$*_container;

####################################3


DOCKER_TARGETS += bb-%
bb-init: DOCKER_CONTAINER = bbb-init 
bb-init: DOCKER_IMAGE = l.gcr.io/google/bazel:0.17.1
bb-init: DOCKER_NETWORKS = host
bb-init: ##@buildbarn init docker container
	@:

bb-%: DOCKER_CONTAINER = bbb-init

bb-shell: | bb-init
	@ /bin/bash


# copy to buildir has been disabled for now ... we do everything within the soruce directory
# this is no clean but esasier to develop.
#
# COPY_TO_BUILDDIR =
# define __copy_to_builddir =
# $(builddir)/$(1): 
# 	@ $(MKDIR_P) $(@D); cp -a $(srcdir)/$(1) $@
# endef
# $(foreach file,$(COPY_TO_BUILDDIR),$(eval $(call __copy_to_builddir,$(builddir)/$(file))))
# 
# BB_BAZEL_FILES = $(builddir)/buildbarn-compose/BUILD.bazel \
#                  $(builddir)/buildbarn-compose/WORKSPACE
# COPY_TO_BUILDDIR += $(BB_BAZEL_FILES)


# TODO: add start registry in localhost:5000  .. run "make docker-registry-init" before
#
# NOTE:
# in case python3 default add the following:
#  --python_top=@io_bazel_rules_docker//python:py_runtime_2
#
bb-build: | $(BB_BAZEL_FILES) bb-init
	@ cd $(srcdir)/buildbarn-compose; \
	  bazel run :bbb_runner_push; \
	  bazel run :bbb_browser_push; \
	  bazel run :bbb_scheduler_push; \
	  bazel run :bbb_frontend_push; \
	  bazel run :bbb_storage_push; \
	  bazel run :bbb_worker_push;



## WORKING HERE .... how to turn this composer file into a swarmable service
## try to investigate REX-Ray volume share
service-bb-up: 
	@ cd $(srcdir)/buildbarn-compose; \
	  source run.sh







