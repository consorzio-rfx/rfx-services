include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

COMPOSER_FILE = docker-composer_v1.yml

SERVICE    = wiki
SWARM_NAME = spider

# rename install targets to spider_wiki
INSTALL_SERVICE_DIR = $(datadir)/$(VENDOR)-services/$(SERVICE_NAME)
INSTALL_STORE_DIR = $(datadir)/$(VENDOR)-services/$(SERVICE_NAME)

# manually edit config_v1.yml.in for now
# export SPIDER_WIKI_URL    = "git@gitlab.igi.cnr.it:spider/spider-codas.wiki.git"
# export SPIDER_WIKI_BRANCH = "master"

start-local: 
stop-local:

# change this when the dns entry will be available
export HOST_NAME = localhost
export PORT = 80
$(INSTALL_TARGETS): HOST_NAME = $(REROUTE_IP)

# config for container
export SSHKEY    = 
export GITURL    = 
export GITBRANCH = 
export DBURL     = mongodb://wikidb:27017/wiki

wiki_rsa:
	@ ssh-keygen -t rsa -b 4096 -C "$(HOSTNAME)@$(STORE_DIR)/$@" -f $@ -q -N "" && \
        echo "paste the following line in gitlab sshkey section"; \
        cat $@.pub

install-data-hook::
	- test -f $(SERVICE_DIR)/wiki_rsa && chmod 400 $(SERVICE_DIR)/wiki_rsa;

SERVICE_DATA = \
               wiki_rsa wiki_rsa.pub \
               config_v1.yml


config_v1.yml: config_v1.yml.in
	@ $(call __ax_pl_envsubst2,$<,$@);


CLEANFILES = config_v1.yml 




## .########..########.##.....##.########.##......
## .##.....##.##.......##.....##.##.......##......
## .##.....##.##.......##.....##.##.......##......
## .##.....##.######...##.....##.######...##......
## .##.....##.##........##...##..##.......##......
## .##.....##.##.........##.##...##.......##......
## .########..########....###....########.########


DOWNLOADS = wiki-v1

wiki-v1: ##@wiki  download code
wiki_v1_URL = https://github.com/Requarks/wiki-v1.git
wiki_v1_BRANCH = master


# config for development
wiki-v1/config.yml: SSHKEY=$(abs_builddir)/wiki_rsa
wiki-v1/config.yml: PORT=8080
wiki-v1/config.yml: DBURL=mongodb://10.0.34.3:27017/wiki
wiki-v1/config.yml: config_v1.yml.in | wiki-v1
	@ $(call __ax_pl_envsubst2,$<,$@);

CLEANFILES += wiki-v1/config.yml



DOCKER_TARGETS = image-%

image-%: DOCKER_CONTAINER = wiki
image-%: DOCKER_IMAGE = requarks/wiki:latest
image-%: DOCKER_NETWORKS = spider_default
image-%: DOCKER_PORTS = 8080:8080 9229:9229 9222:9222 3000:3000
image-init:
	@:

image-install: USER=root
image-install:
	@ apk add ncurses make g++

image-shell:
	@ bash

wiki-prepare: wiki-v1/config.yml image-init image-install

DOCKER_TARGETS += wiki-dev
wiki-dev: DOCKER_CONTAINER = wiki
wiki-dev: 
	@ cd wiki-v1; \
	  npm install; \
	  yarn run dev



wiki-start: ##@wiki start wiki development
wiki-start: wiki-prepare wiki-dev

DOCKER_TARGETS += wiki-stop
wiki-stop: ##@wiki stop wiki development
wiki-stop: DOCKER_CONTAINER = wiki
wiki-stop:
	@ cd wiki-v1; \
	  yarn run stop


# DOCKER_TARGETS += wiki-dev-config
# wiki-dev-config: DOCKER_CONTAINER = wiki
# wiki-dev-config: 
# 	@ cd wiki-v1; \
# 	  yarn run dev-configure