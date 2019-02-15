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

export REROUTE_IP = 192.168.60.158
export REROUTE_PORTS = 80:80

# change this when the dns entry will be available
export HOST_NAME = localhost
$(INSTALL_TARGETS): HOST_NAME = $(REROUTE_IP)

wiki_rsa:
	@ ssh-keygen -t rsa -b 4096 -C "$(HOSTNAME)@$(STORE_DIR)/$@" -f $@ -q -N "" && \
        echo "paste the following line in gitlab sshkey section"; \
        cat $@.pub

install-data-hook::
	- test -f $(SERVICE_DIR)/wiki_rsa && chmod 400 $(SERVICE_DIR)/wiki_rsa;

SERVICE_DATA = img \
               wiki_rsa wiki_rsa.pub \
               config_v1.yml

config_v1.yml: config_v1.yml.in
	@ $(call __ax_pl_envsubst2,$<,$@);


CLEANFILES = config_v1.yml