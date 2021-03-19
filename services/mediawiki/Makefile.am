include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = mediawiki:rfx
COMPOSER_FILE = docker-compose.yml

# Se serve lavorare sui sorgenti...
# SERVICE_DIR_COPY = $(STORE_DIR)/html:/var/www/html

image: ##@docker_services build image
image:
	docker build $(srcdir)/src -t $(DOCKER_IMAGE)

start-local: $(DIRECTORIES) create-dirs image
stop-local:


STORE_DATA = assets \
			 extensions \
			 logo \
			 skins \
			 images \
			 rfxwiki.sqlite 

SERVICE_DATA = LocalSettings.php \
			   ldap.json \
			   log 
			   

export WG_SITENAME = RFX intranet


