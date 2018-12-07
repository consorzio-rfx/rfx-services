
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



## NOT WORKING YET ##
##
tf-cache: ##@tf build tensorflow starting docker swarm for that
tf-cache: SWARM_NAME = tf-cache
tf-cache: COMPOSER_FILE = $(srcdir)/docker-compose_bazel.yml
tf-cache: DOCKER_IMAGE  = buchgr/bazel-remote-cache
tf-cache: $(BAZEL_CACHEDIR) start


export BAZEL_CACHEDIR
export DOCKER_CONTAINER
export DOCKER_IMAGE

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
      bazel build --remote_http_cache=http://localhost:9090 \
       --spawn_strategy=standalone \
       --config=opt //tensorflow/tools/pip_package:build_pip_package

shell: tf-init
	@ /bin/bash




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



# Bazel Itself
# To have bazel use the bazel buildfarm configured using the example configs provided in the examples directory, you could configure your .bazelrc as follows:
# 
# $ cat .bazelrc
# build --spawn_strategy=remote --genrule_strategy=remote --strategy=Javac=remote --strategy=Closure=remote --remote_executor=localhost:8980
# Then run your build as you would normally do.


##      .########.....###....########.########.##...........########.....###....########..##....##
##      .##.....##...##.##........##..##.......##...........##.....##...##.##...##.....##.###...##
##      .##.....##..##...##......##...##.......##...........##.....##..##...##..##.....##.####..##
##      .########..##.....##....##....######...##...........########..##.....##.########..##.##.##
##      .##.....##.#########...##.....##.......##...........##.....##.#########.##...##...##..####
##      .##.....##.##.....##..##......##.......##...........##.....##.##.....##.##....##..##...###
##      .########..##.....##.########.########.########.....########..##.....##.##.....##.##....##


DOWNLOADS += buildbarn

buildbarn_URL = https://github.com/EdSchouten/bazel-buildbarn.git
buildbarn_BRANCH = master

buildbarn-browser: ##@buildbarn browser
buildbarn-frontend: ##@buildbarn frontend

buildbarn-%: | buildbarn
	@ cd buildbarn; \
      bazel build //cmd/bbb_$*:bbb_$*_container;




