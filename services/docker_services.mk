NODOCKERBUILD = %


mkfile_path = $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir = $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
ak__default_value = $(if $($1),,$(eval $1 = $2))

$(call ak__default_value,VENDOR,rfx)
$(call ak__default_value,SERVICE,$(current_dir))
$(call ak__default_value,SWARM_NAME,$(current_dir))
$(call ak__default_value,SERVICE_NAME,$(SWARM_NAME)_$(SERVICE))

# VENDOR        := $(or $(VENDOR),rfx)
# $(if $(SERVICE),,$(eval SERVICE = $(current_dir)))
# $(if $(SWARM_NAME),,$(eval SWARM_NAME = $(current_dir)))
# $(if $(SERVICE_NAME),,$(eval SERVICE_NAME = $(SWARM_NAME)_$(SERVICE)))

SERVICE_DIR   = $(abs_srcdir)
STORE_DIR     = $(abs_builddir)
date          = $(shell date)

export srcdir
export builddir
export top_srcdir
export top_builddir
export abs_top_srcdir
export abs_top_builddir

export  SWARM_NAME \
		SERVICE \
		SERVICE_NAME \
		STORE_DIR \
		SERVICE_DIR \
		SERVICE_EXPORTS \
		REROUTE_IP \
    	REROUTE_PORTS \
    	COMPOSER_FILE \
		DOCKER_IMAGE \
		date

## RFX SERVICES VARIABLES ##
export SMTP_SERVER_HOST  \
       SMTP_SERVER_PORT  \
	   EMAIL_SMTP_SECURE \
	   EMAIL_SMTP_USER   \
	   EMAIL_SMTP_PASS   \
	   EMAIL_SMTP_TLS_REJECT_UNAUTH \
	   EMAIL_SMTP_TLS_REJECT_UNAUTH_TF \
	   EMAIL_SMTP_IGNORE_TLS \
	   EMAIL_SMTP_IGNORE_TLS_TF \
			 email_notreply \
			 email_administrator \
			 ldap_host \
			 ldap_port \
			 ldap_usernameid \
			 ldap_bind_dn \
			 ldap_search_password \
			 ldap_encription \
			 ldap_base



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
start: | swarm-init start-local $(COMPOSER_FILE)
	@ $(info stack deploy for service) \
	  docker stack deploy -c $(COMPOSER_FILE) $(SWARM_NAME); \
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
	@ $(info loking service logs) \
	  docker service logs $(SERVICE_NAME) -f

shell: ##@docker_services enter instance shell
shell:
	@ $(info login into $(SERVICE_NAME).$(or $(ID),1)) \
	  _id=`docker service ps $(SERVICE_NAME) -q`; \
	  docker exec -ti $(SERVICE_NAME).$(or $(ID),1).$${_id} $(SHELL)

compose-up:   ##@@docker_composer local command up
compose-down: ##@@docker_composer local command down
compose-logs: ##@@docker_composer local command logs
compose-up:
	@ docker-compose -f ${COMPOSER_FILE} up -d $(SERVICE)
compose-logs:
	@ docker-compose -f ${COMPOSER_FILE} logs -f $(SERVICE)
compose-down:
	@ docker-compose -f ${COMPOSER_FILE} down

portainer-init: ##@docker_services poirtainer init (browse localhost:9000 then)
portainer-init:
	@ docker volume create portainer_data; \
      docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer


docker-registry-init: ##@docker_services registry init (provide an image registry at localhost:5000)
docker-registry-init:
	@ docker service create --name registry --publish 5000:5000 registry:2


reroute: $(abs_top_srcdir)/services/service_reroute.sh
	@ sudo -E $^ -s $(SERVICE_NAME) reroute_ports ||:

reroute-clear: $(abs_top_srcdir)/services/service_reroute.sh
	@ sudo -E $^ -s $(SERVICE_NAME) clear_ports ||:


##
## INSTALL TARGETS
##
INSTALL_TARGETS = install install-% $(install_service_DATA) $(install_store_DATA)
# INSTALL_TARGETS_VARIABLES = SERVICE SWARM_NAME SERVICE_NAME
# SERVICE_I      = $(VENDOR)-$(SERVICE)
# SWARM_NAME_I   = $(VENDOR)-$(SWARM_NAME)
# SERVICE_NAME_I = $(VENDOR)-$(SERVICE_NAME)

# install-print:
# 	@ echo "$(SERVICE) --> $(install_servicedir), $(SERVICEdir)"
# 	@ echo "SERVICE = $(SERVICE)"
# 	@ echo "SWARM = $(SWARM_NAME)"
# 	@ echo "SERVICE_NAME = $(SERVICE_NAME)"

install_servicedir = $(or $(INSTALL_SERVICE_DIR),$(datadir)/$(VENDOR)-services/$(SERVICE))
install_storedir   = $(or $(INSTALL_STORE_DIR),$(datadir)/$(VENDOR)-services/$(SERVICE))

install_tmpdir   = .install
ak__DIRECTORIES += $(install_tmpdir)

install_service_DATA = $(install_tmpdir)/$(notdir $(COMPOSER_FILE)) \
					   $(install_tmpdir)/$(SERVICE_CONFIG_FILE) \
					   $(install_tmpdir)/$(SYSTEMD_SERVICE_FILE)

install_store_DATA =

install-data-hook:
	- $(MAKE) -C $(top_builddir)/services/ install SUBDIRS="" # install service utils
	- systemctl link -f $(SERVICE_DIR)/$(SYSTEMD_SERVICE_FILE); \
	  systemctl daemon-reload

##
## TEMPLATES
##
__ax_pl_envsubst  ?= $(PERL) -pe 's/([^\\]|^)\$$\{([a-zA-Z_][a-zA-Z_0-9]*)\}/$$1.$$ENV{$$2}/eg;s/\\\$$/\$$/g;' < $1 > $2
__ax_pl_envsubst2 ?= $(PERL) -pe 's/([^\\]|^)\$$\(([a-zA-Z_][a-zA-Z_0-9]*)\)/$$1.$$ENV{$$2}/eg;s/\\\$$/\$$/g;' < $1 > $2

export datadir
export SERVICE_CONFIG_FILE   = $(SERVICE).conf
export SYSTEMD_SERVICE_FILE  = $(VENDOR)-$(SERVICE).service

# $(foreach v,$(INSTALL_TARGETS_VARIABLES),$(eval $(INSTALL_TARGETS): $v := $($v_I)))
$(INSTALL_TARGETS): SERVICE_DIR   := $(install_servicedir)
$(INSTALL_TARGETS): STORE_DIR     := $(install_storedir)
$(INSTALL_TARGETS): COMPOSER_FILE := $(install_servicedir)/$(notdir $(COMPOSER_FILE))

$(install_tmpdir)/$(SERVICE_CONFIG_FILE): $(abs_top_srcdir)/services/service.config.template | $(install_tmpdir)
	@ $(call __ax_pl_envsubst2,$<,$@);

$(install_tmpdir)/$(SYSTEMD_SERVICE_FILE): $(abs_top_srcdir)/services/systemd.service.template | $(install_tmpdir)
	@ $(call __ax_pl_envsubst2,$<,$@);

$(COMPOSER_FILE): $(wildcard $(srcdir)/$(COMPOSER_FILE).in)
	@ $(if $<,$(call __ax_pl_envsubst2,$<,$@),$(error missing $(srcdir)/$(COMPOSER_FILE).in));

$(install_tmpdir)/$(notdir $(COMPOSER_FILE)): $(wildcard $(srcdir)/$(COMPOSER_FILE).in) | $(install_tmpdir)
	@ $(if $<,$(call __ax_pl_envsubst2,$<,$@),cp $(srcdir)/$(@F) $@); ## if composer_file.in exists parse it

MOSTLYCLEANFILES = $(install_service_DATA) $(install_store_DATA)

##
## NOTE: this was rewritten from Makefile and maches the default, but it seems that it must be redeclared to be written in
##       the right order within the generated Makefile
##
all-am: Makefile $(DATA) $(COMPOSER_FILE)














##    .########..##....##....########....###....########...######...########.########
##    .##.....##.##...##........##......##.##...##.....##.##....##..##..........##...
##    .##.....##.##..##.........##.....##...##..##.....##.##........##..........##...
##    .##.....##.#####..........##....##.....##.########..##...####.######......##...
##    .##.....##.##..##.........##....#########.##...##...##....##..##..........##...
##    .##.....##.##...##........##....##.....##.##....##..##....##..##..........##...
##    .########..##....##.......##....##.....##.##.....##..######...########....##...

export DOCKER_CONTAINER
export DOCKER_IMAGE
export DOCKER_URL
export DOCKER_DOCKERFILE
export DOCKER_SHELL = /bin/sh
export DOCKER_REGISTRY

DSHELL = $(top_srcdir)/c onf/dk.sh ${DSHELL_ARGS}
NO_DOCKER_TARGETS = Makefile $(srcdir)/Makefile.in $(srcdir)/Makefile.am $(top_srcdir)/configure.ac $(ACLOCAL_M4) $(top_srcdir)/configure am--refresh \
                    $(am__aclocal_m4_deps) $(am__configure_deps) $(top_srcdir)/%.mk \
					docker-%
NODOCKERBUILD += ${DOCKER_TARGETS} #this is needed for build with docker

# DSHELL_ARGS = -v
$(DOCKER_TARGETS): override SHELL = $(DSHELL)
$(NO_DOCKER_TARGETS): override SHELL = /bin/sh
$(NO_DOCKER_TARGETS): override HAVE_DOCKER = no

docker-clean: ##@@docker_target clean docker container conf in .docker directory
docker-start: ##@@docker_target start advanced per target docker container
docker-stop:  ##@@docker_target stop advanced per target docker container
docker-:      ##@@docker_target advanced per target docker (any command passed to conf/dk.sh)
docker-%:
	@ $(info [docker] $*)
	@ . $(DSHELL) $*






##    .########...#######..##.......##....##.##.....##..#######..########..########..##.....##
##    .##.....##.##.....##.##........##..##..###...###.##.....##.##.....##.##.....##.##.....##
##    .##.....##.##.....##.##.........####...####.####.##.....##.##.....##.##.....##.##.....##
##    .########..##.....##.##..........##....##.###.##.##.....##.########..########..#########
##    .##........##.....##.##..........##....##.....##.##.....##.##...##...##........##.....##
##    .##........##.....##.##..........##....##.....##.##.....##.##....##..##........##.....##
##    .##.........#######..########....##....##.....##..#######..##.....##.##........##.....##

SERVICEdir = $(install_servicedir)
SOTREdir   = $(install_storedir)

install-SERVICEDATA:
	@ $(MAKE) dk__$@

dk__install-SERVICEDATA:
	@$(NORMAL_INSTALL)
	@list='$(SERVICE_DATA)'; test -n "$(SERVICEdir)" || list=; \
	 if test -n "$$list"; then \
	   echo " $(MKDIR_P) '$(DESTDIR)$(SERVICEdir)'"; \
	   $(MKDIR_P) "$(DESTDIR)$(SERVICEdir)" || exit 1; \
	 fi; \
	 for p in $$list; do \
	   if test -f "$$p"; then echo "$$p"; \
	   else p="$(srcdir)/$$p"; \
	    if test -f "$$p"; then echo "$$p"; fi; \
	   fi; \
	 done | $(am__base_list) | \
	 while read files; do \
	   echo " $(INSTALL_DATA) $$files '$(DESTDIR)$(SERVICEdir)'"; \
	   $(INSTALL_DATA) $$files "$(DESTDIR)$(SERVICEdir)" || exit $$?; \
	 done; \
	 for p in $$list; do \
	   if test -d "$$p"; then echo "$$p"; \
	   else p="$(srcdir)/$$p"; \
	    if test -d "$$p"; then echo "$$p"; fi; \
	   fi; \
	 done | $(am__base_list) | \
	 while read drs; do \
	 	echo "copy directory: $$drs to $(DESTDIR)$(SERVICEdir)"; \
	 	cp -an $$drs "$(DESTDIR)$(SERVICEdir)"; \
	 done


install-STOREDATA:
	@ $(MAKE) dk__$@

dk__install-STOREDATA:
	@$(NORMAL_INSTALL)
	@list='$(STORE_DATA)'; test -n "$(STOREdir)" || list=; \
	 if test -n "$$list"; then \
	   echo " $(MKDIR_P) '$(DESTDIR)$(STOREdir)'"; \
	   $(MKDIR_P) "$(DESTDIR)$(STOREdir)" || exit 1; \
	 fi; \
	 for p in $$list; do \
	   if test -f "$$p"; then echo "$$p"; \
	   else p="$(srcdir)/$$p"; \
	    if test -f "$$p"; then echo "$$p"; fi; \
	   fi; \
	 done | $(am__base_list) | \
	 while read files; do \
	   echo " $(INSTALL_DATA) $$files '$(DESTDIR)$(STOREdir)'"; \
	   $(INSTALL_DATA) $$files "$(DESTDIR)$(STOREdir)" || exit $$?; \
	 done; \
	 for p in $$list; do \
	   if test -d "$$p"; then echo "$$p"; \
	   else p="$(srcdir)/$$p"; \
	    if test -d "$$p"; then echo "$$p"; fi; \
	   fi; \
	 done | $(am__base_list) | \
	 while read drs; do \
	 	echo "copy directory: $$drs to $(DESTDIR)$(STOREdir)"; \
	 	cp -an $$drs "$(DESTDIR)$(STOREdir)"; \
	 done
















