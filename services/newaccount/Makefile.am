include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk
include $(top_srcdir)/services/docker_machine.mk

##    ..######..########.########..##.....##.####..######..########
##    .##....##.##.......##.....##.##.....##..##..##....##.##......
##    .##.......##.......##.....##.##.....##..##..##.......##......
##    ..######..######...########..##.....##..##..##.......######..
##    .......##.##.......##...##....##...##...##..##.......##......
##    .##....##.##.......##....##....##.##....##..##....##.##......
##    ..######..########.##.....##....###....####..######..########

COMPOSER_FILE  = docker-composer.yml
REROUTE_IP     = 192.168.60.156
REROUTE_PORTS  = 80:80

start-local:
stop-local:

SERVICE_DATA = newaccount



##    .####.##.....##....###.....######...########
##    ..##..###...###...##.##...##....##..##......
##    ..##..####.####..##...##..##........##......
##    ..##..##.###.##.##.....##.##...####.######..
##    ..##..##.....##.#########.##....##..##......
##    ..##..##.....##.##.....##.##....##..##......
##    .####.##.....##.##.....##..######...########

DOCKER_TARGETS = image-%
image-%: DOCKER_CONTAINER = newaccount
image-%: DOCKER_IMAGE = consorziorfx/newaccount:latest
image-init: DOCKER_DOCKERFILE = $(srcdir)/Dockerfile
image-init: DOCKER_URL = $(srcdir)
image-init: 
	@ :;

image-push: DOCKER_REGISTRY = $(DOCKER_REGISTRY_SERVER_HOST):$(DOCKER_REGISTRY_SERVER_PORT)
image-push: image-init docker-push

image-clean: docker-clean

## CLEAN
clean-local: image-clean


## ALL
all: image-init
















