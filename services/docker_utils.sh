#!/bin/bash
# DOCKER UTILS

SCRIPTNAME=$(basename "$0")
SCRIPT_DIR=$(dirname "$0")
CONFIG_FILE=

##     .##.....##.########.####.##........######.
##     .##.....##....##.....##..##.......##....##
##     .##.....##....##.....##..##.......##......
##     .##.....##....##.....##..##........######.
##     .##.....##....##.....##..##.............##
##     .##.....##....##.....##..##.......##....##
##     ..#######.....##....####.########..######.

SELFHELP_FUNC='
    %help;
    while(<>) {
        if(/^\#([a-zA-Z0-9_\-\.]+):.*\#\#(?:@(\w+))?\s(.*)$/) {
            push(@{$help{$2}}, [$1, $3]);
            print "found";
        }
    };
    print "\n";
    print "| \n";
    print "| ${SH_GREEN}list of commands ${SH_RESET}\n";
    print "| \n";
    for ( sort keys %help ) {
        print "| ${SH_YELLOW}$_${SH_RESET}:\n";
        printf("|   %-20s %-60s\n", $_->[0], $_->[1]) for @{$help{$_}};
        print "| \n";
    }
    print "\n";'

#help: ## get help on commands
help() {
   perl -e "${SELFHELP_FUNC}" $0
}

retry() {
   local n=0
   until [ $n -ge $1 ]
   do
      echo "testing for ${@:2}  [ attempt = $n ]"
      ${@:2} && break
      n=$[$n+1]
      sleep 5
   done
}

# service_reroute <options> [-s service_name] [command]
service_reroute() {
    echo "rerouting service ..."
    ${SCRIPT_DIR}/service_reroute.sh $@
}

# stack_reroute swarm_name <options> [command]
stack_reroute() {
    inspect () { echo $(docker service inspect $1 --format="$2"); }
    echo "rerouting stack ..."
    local id_list=$(docker stack services $1 -q)
    for _id in ${id_list}; do
        local s_name=$(inspect $_id "{{.Spec.Name}}")
        service_reroute -s $s_name ${@:2} ||:;
    done
}

##    ..######..##......##....###....########..##.....##
##    .##....##.##..##..##...##.##...##.....##.###...###
##    .##.......##..##..##..##...##..##.....##.####.####
##    ..######..##..##..##.##.....##.########..##.###.##
##    .......##.##..##..##.#########.##...##...##.....##
##    .##....##.##..##..##.##.....##.##....##..##.....##
##    ..######...###..###..##.....##.##.....##.##.....##

#swarm-init: ##@docker_services init swarm
swarm-init() {
    docker swarm init  2> /dev/null ||:
}

#swarm-leave: ##@docker_services leave swarm
swarm-leave() {
    docker swarm leave --force ||:
}

#start: ##@docker_services start service
start() {
    retry 3 swarm-init
    retry 3 docker -D stack deploy -c ${COMPOSER_FILE} ${SWARM_NAME}
    stack_reroute ${SWARM_NAME} reroute_ports
}

#stop: ##@docker_services stop service
stop() {
    stack_reroute ${SWARM_NAME} clear_ports
    docker -D stack rm ${SWARM_NAME}    
}

# #ps: ##@docker_services list services
# ps() {
#     docker service ps ${SERVICE_NAME}
# }

#logs: ##@docker_services see logs
logs() {    
    docker service logs ${SERVICE_NAME} -f
}

#shell: ##@docker_services enter instance shell
shell() {
    _id=$(docker service ps ${SERVICE_NAME} -q | cut -d' ' -f1)
    [ $_id ] && docker exec -ti ${SERVICE_NAME}.1.${_id} ${DOCKER_SHELL}
}





#      .##.....##....###....####.##....##
#      .###...###...##.##....##..###...##
#      .####.####..##...##...##..####..##
#      .##.###.##.##.....##..##..##.##.##
#      .##.....##.#########..##..##..####
#      .##.....##.##.....##..##..##...###
#      .##.....##.##.....##.####.##....##

print_help() {
cat << EOF

Usage: $SCRIPTNAME [options] [commands]

       options
       -------
       -h|--help)         get this help
       -v|--verbose)      show script source script
       -c|--config)       service config file
       -debug)            show debug info

EOF
}

## parse cmd parameters:
while [[ "$1" == -* ]] ; do
	case "$1" in
		-h|--help)
			print_help
			exit
			;;
        -v|--verbose)
	        #set -ex -o verbose
			set -ex
			shift
			;;
        -c|--config)
            CONFIG_FILE=$2
            shift 2
            ;;
		--)
			shift
			break
			;;
		*)
            COMMAND=$1
            shift
		    break
			;;
	esac
done

if [ $# -lt 1 ] ; then
	echo "Incorrect parameters. Use --help for usage instructions."
fi

##
## VARS
##

# ensure profile
# . /etc/profile

COMPOSER_FILE=docker-compose.yml
SWARM_NAME=
SERIVCE_NAME=

if [ ${CONFIG_FILE} ]; then
 . ${CONFIG_FILE}
fi

## EVAL COMMAND ##
$@





