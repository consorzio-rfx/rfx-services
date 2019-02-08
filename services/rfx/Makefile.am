include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk
include $(top_srcdir)/services/docker_machine.mk



COMPOSER_FILE = docker-compose.yml
SERVICE = registry

start-local:
stop-local:

networks.yml: networks.yml.in
	@ $(call __ax_pl_envsubst2,$<,$@);


##     .##.....##....###.....######..##.....##.####.##....##.########
##     .###...###...##.##...##....##.##.....##..##..###...##.##......
##     .####.####..##...##..##.......##.....##..##..####..##.##......
##     .##.###.##.##.....##.##.......#########..##..##.##.##.######..
##     .##.....##.#########.##.......##.....##..##..##..####.##......
##     .##.....##.##.....##.##....##.##.....##..##..##...###.##......
##     .##.....##.##.....##..######..##.....##.####.##....##.########

# this is a simple test of the docker machine integration foreseen for 
# autoconf-bootstrap project. Further development will be done in the 
# dk.sh script file.

DOCKER_MACHINES = dev1

etargets = ls bash
DOCKER_TARGETS = $(etargets)
$(etargets): DOCKER_CONTAINER = etargets
$(etargets): DOCKER_IMAGE = rigoni/linux-socdev:latest
$(etargets): DOCKER_MACHINE = dev1
$(etargets):
	@$@


