
NODOCKERBUILD = %

mkfile_path = $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir = $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

SWARM_NAME    ?= $(current_dir)
SERVICE       ?= $(current_dir)
SERVICE_NAME  ?= $(SWARM_NAME)_$(SERVICE)

VENDOR        ?= rfx
VERSION       ?= 1.0

## export \
##        SMTP_SERVER_HOST \
##        SMTP_SERVER_PORT

.PHONY: swarm-init swarm-leave start stop ps logs shell

swarm-init: ##@docker initialize this machine as a swarm manager
swarm-init:
	@ $(info swarm init) \
	  docker swarm init  2> /dev/null ||:

swarm-leave: ##@docker swarm leave
swarm-leave:
	@ $(info swarm leave) \
	  docker swarm leave --force ||:

start: ##@docker_services stack deploy service
start: | swarm-init start-local
	@ $(info stack deploy for service) \
	  docker stack deploy -c ${COMPOSER_FILE} $(SWARM_NAME); \
      $(MAKE) reroute

stop: ##@docker_services remove service
stop: | stop-local
	@ $(info remove current service) \
	  docker stack rm $(SWARM_NAME); \
      $(MAKE) reroute-clear

ps: ##@docker_services list services
ps:
	@ $(info list process in current service) \
	  docker service ps $(SERVICE_NAME)

logs: ##@docker_services see logs
logs:
	@ $(info loking gitlab logs) \
	  docker service logs $(SERVICE_NAME) -f

shell: ##@docker_services enter instance shell
shell:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(SHELL)

#compose-up: ##@docker_composer local command up
#compose-down: ##@docker_composer local command down
#compose-up:
#	@ docker-compose -f ${COMPOSER_FILE} up -d $(SERVICE)
#compose-logs:
#	@ docker-compose -f ${COMPOSER_FILE} logs -f $(SERVICE)
#compose-down:
#	@ docker-compose -f ${COMPOSER_FILE} down

portainer-init: ##@docker_services poirtainer init (browse localhost:9000 then)
portainer-init:
	@ docker volume create portainer_data; \
      docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

reroute: $(abs_top_srcdir)/services/service_reroute.sh
	@ $^ -s $(SERVICE_NAME) reroute_ports

reroute-clear: $(abs_top_srcdir)/services/service_reroute.sh
	@ $^ -s $(SERVICE_NAME) clear_ports
