include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DIRECTORIES = config

DOCKER_IMAGE  = gitlab/gitlab-runner:alpine
COMPOSER_FILE = docker-compose.yml

start-local: config
stop-local:

URL     = https://gitlab.igi.cnr.it
TOKEN   = unpnaFzr9yK3GKJEK7YY
TAGS    = rfx
OPTIONS = --run-untagged --non-interactive


runner-:     ##@gitlab runner commands (use make runner-help) $ARGS
runner-%:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} gitlab-runner $* $(ARGS)

runner-list: ##@gitlab runner list active runners


_register_args = gitlab-runner register \
     --config /etc/gitlab-runner/config.toml \
	 $(OPTIONS) \
     --url $(URL) \
     --registration-token $(TOKEN) \
     --name $(1) \
     --tag-list $(TAGS) \
     --locked \
     --paused \
     $2

register: ##@gitlab register instance interactively
register: NAME := $(or $(NAME),$(call ak__fname,$(HOSTNAME))_runner_shell)
register:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(_register_args,$(NAME),)

unregister-all: ##@gitlab unregister all runners
unregister-all:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} gitlab-runner unregister --all-runners


_executor_shell_args = --executor shell

register-shell: ##@gitlab register new instance with shell executor
register-shell: NAME := $(or $(NAME),$(call ak__fname,$(HOSTNAME))_runner_shell)
register-shell: COMMAND = $(call _register_args,$(NAME),$(_executor_shell_args))
register-shell: TAGS    = rfx,shell
register-shell:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(COMMAND)




_executor_docker_args =  --executor docker \
                         --docker-image docker:latest \
                         --docker-privileged true

register-docker: ##@gitlab register new instance with docker executor
register-docker: NAME := $(or $(NAME),$(call ak__fname,$(HOSTNAME))_runner_docker)
register-docker: COMMAND = $(call _register_args,$(NAME),$(_executor_docker_args))
register-docker: TAGS    = rfx,docker
register-docker:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(COMMAND)



## Refer to this documentation
## https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
## 


