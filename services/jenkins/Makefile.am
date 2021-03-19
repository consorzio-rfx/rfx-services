include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

DOCKER_IMAGE  = jenkins/jenkins:rfx
COMPOSER_FILE = docker-compose.yml

SERVICE_DIR_COPY = $(STORE_DIR)/jenkins-data:/var/jenkins_home

start-local: $(DIRECTORIES) create-dirs
stop-local:



jenkins_script_trigger: JENKINS_HOST      = http://spilds:8080
jenkins_script_trigger: JENKINS_USER_ID   = andrea
jenkins_script_trigger: JENKINS_API_TOKEN = 11b6c4db3070de179583b1a3e07240094b

jenkins_script_trigger:
	$(info starting jenkins script $(JENKINS_USER_ID):$(JENKINS_API_TOKEN))
	curl --user "$(JENKINS_USER_ID):$(JENKINS_API_TOKEN)" --data-urlencode \
	 "script=$$(< $(SCRIPT))" $(JENKINS_HOST)/scriptText


jenkins-init:
	$(MAKE) jenkins_script_trigger SCRIPT=./jenkins-scripts/install_plugin.groovy;


