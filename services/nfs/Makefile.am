include $(top_srcdir)/Common.mk
include $(top_srcdir)/services/docker_services.mk

##    .##....##..#######..########....##......##..#######..########..##....##.####.##....##..######..
##    .###...##.##.....##....##.......##..##..##.##.....##.##.....##.##...##...##..###...##.##....##.
##    .####..##.##.....##....##.......##..##..##.##.....##.##.....##.##..##....##..####..##.##.......
##    .##.##.##.##.....##....##.......##..##..##.##.....##.########..#####.....##..##.##.##.##...####
##    .##..####.##.....##....##.......##..##..##.##.....##.##...##...##..##....##..##..####.##....##.
##    .##...###.##.....##....##.......##..##..##.##.....##.##....##..##...##...##..##...###.##....##.
##    .##....##..#######.....##........###..###...#######..##.....##.##....##.####.##....##..######..


COMPOSER_FILE = docker-compose.yml

start-local: | $(STORE_DIR)/data
stop-local:

export GANESHA_CONFIGFILE = /ganesha.conf
export GANESHA_EXPORT_ID = 77
export GANESHA_EXPORT = /data/nfs
export GANESHA_PSEUDO_PATH = /
export GANESHA_NFS_PROTOCOLS = 4
export GANESHA_TRANSPORTS = TCP

export GANESHA_ACCESS = *
export GANESHA_ROOT_ACCESS = *

# GANESHA_LOGFILE: log file location
# GANESHA_CONFIGFILE: location of ganesha.conf
# GANESHA_OPTIONS: command line options to pass to ganesha
# GANESHA_EPOCH: ganesha epoch value
# GANESHA_EXPORT_ID: ganesha unique export id
# GANESHA_EXPORT: export location
# GANESHA_ACCESS: export access acl list
# GANESHA_ROOT_ACCESS: export root access acl list
# GANESHA_NFS_PROTOCOLS: nfs protocols to support
# GANESHA_TRANSPORTS: nfs transports to support
# STARTUP_SCRIPT: location of a shell script to execute on start


DIRECTORIES = $(STORE_DIR)/data
SERVICE_DATA = $(STORE_DIR)/data


compose-%:  $(COMPOSER_FILE)
	@ docker-compose -f $(COMPOSER_FILE) $*

