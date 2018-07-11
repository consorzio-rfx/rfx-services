
include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

all: build

build: Dockerfile start-btsync
	@ $(info create docker image) \
      cp $^ .; \
      docker build -t rigoni/btsync:latest .

rslsync.sample:
	@ rslsync --dump-sample-config > $(srcdir)/$@
