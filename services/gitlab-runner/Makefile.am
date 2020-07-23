include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DIRECTORIES = config

DOCKER_IMAGE  = gitlab/gitlab-runner:alpine
COMPOSER_FILE = docker-compose.yml

start-local: config
stop-local:


_script = gitlab-runner register \
     --config /etc/gitlab-runner/config.toml \
     --non-interactive \
     --url https://gitlab.igi.cnr.it \
     --registration-token NDW4DYRQK9XCykexyQs1 \
     --name gitlab-ci-splids-runner \
     --tag-list shell,rfx \
     --locked \
     --paused \
     --executor shell
    
register: ##@gitlab register instance shell
register:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(_script)
