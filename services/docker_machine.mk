


export MACHINE_NAME
export DOCKER_MACHINE
export abs_top_srcdir
export abs_top_builddir

export DOCKER_MACHINE_ISO
export DOCKER_MACHINE_ARGS
export DOCKER_MACHINE_SORAGE_PATH ?= $(abs_top_builddir)/conf/.docker


DSHELL ?= $(top_srcdir)/conf/dk.sh ${DSHELL_ARGS}
NODOCKERBUILD += ${DOCKER_MACHINES} #this is needed for build with docker


$(DOCKER_MACHINES):
	@ $(MAKE) machine-create MACHINE_NAME=$@


machine-%: DOCKER_CONTAINER = none
machine-%: DOCKER_MACHINE_ARGS := $(or $($(MACHINE_NAME)_ARGS),$(DOCKER_MACHINE_ARGS))
machine-%: DOCKER_MACHINE_ISO  := $(or $($(MACHINE_NAME)_ISO),$(DOCKER_MACHINE_ISO))
machine-%: 
	$(DSHELL) machine-$*







