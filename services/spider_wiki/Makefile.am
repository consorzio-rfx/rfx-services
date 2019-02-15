include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

COMPOSER_FILE = docker-composer_v1.yml

SERVICE    = wiki
SWARM_NAME = spider

start-local: 
stop-local:

export REROUTE_IP = 192.168.60.158
export REROUTE_PORTS = 80:80

# change this when dns available
export HOST_NAME = $(REROUTE_IP)

wiki_rsa:
	@ ssh-keygen -t rsa -b 4096 -C "$(HOSTNAME)@$(STORE_DIR)/$@" -f $@ -q -N ""; \
      echo "paste the following line in gitlab sshkey section"; \
      cat $@.pub

SERVICE_DATA = $(srcdir)/config_v1.yml \
               wiki_rsa wiki_rsa.pub \
               config_v1.yml

config_v1.yml: config_v1.yml.in
	@ $(call __ax_pl_envsubst2,$<,$@);