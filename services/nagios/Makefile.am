include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = jasonrivers/nagios:latest
COMPOSER_FILE = docker-compose.yml

start-local: spider-audit
stop-local:

# SERVICE_DATA =  rfx_plugins
STORE_DATA = $(builddir)/spider-audit

SERVICE_DIR_COPY = $(SERVICE_DIR)/nagios_etc:/opt/nagios/etc \
                   $(STORE_DIR)/nagios_var:/opt/nagios/var

DOWNLOADS = spider-audit
spider-audit: ##@spider download spider nagios scripts
spider_audit_URL = https://gitlab.igi.cnr.it/spider/spider-audit.git
spider_audit_BRANCH = master

