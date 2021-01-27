include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk


DOWNLOADS = open-balena

open-balena: ##@balena download open-balena script repo

open_balena_DIR = open-balena
open_balena_URL = https://github.com/balena-io/open-balena.git
open_balena_BRANCH = master


SCRIPT_DIR = $(builddir)/open-balena/scripts
CONFIG_DIR = $(builddir)/open-balena/config

BALENA_USER_EMAIL = andrea.rigoni@igi.cnr.it
BALENA_USER_PASSWD = openbalena
BALENA_DOMAIN = balena.rfx.local

quickstart: | open-balena
	$(SCRIPT_DIR)/quickstart -U $(BALENA_USER_EMAIL) -P $(BALENA_USER_PASSWD) -d $(BALENA_DOMAIN); \
	echo ""; \
	echo "add these two lines in your SERVER /etc/hosts file"; \
	echo "127.0.0.1	db.$(BALENA_DOMAIN)"; \
	echo "127.0.0.1	redis.$(BALENA_DOMAIN)"; \
	echo ""; \
	echo "add these lines in your CLIENTS /etc/hosts file"; \
	echo "<server ip>	api.$(BALENA_DOMAIN)"; \
	echo "<server ip>	registry.$(BALENA_DOMAIN)"; \
	echo "<server ip>	vpn.$(BALENA_DOMAIN)"; \
	echo "<server ip>	s3.$(BALENA_DOMAIN)";

$(CONFIG_DIR)/activate: quickstart

COMPOSER_FILE = docker-compose.yml
$(COMPOSER_FILE): $(CONFIG_DIR)/activate
	@ $(SCRIPT_DIR)/compose config > $@


start-local:
stop-local:

start: $(COMPOSER_FILE) 
	source $(CONFIG_DIR)/activate; $(SCRIPT_DIR)/compose up #-d

stop:
	$(SCRIPT_DIR)/compose down
