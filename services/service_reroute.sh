#!/bin/bash
# //////////////////////////////////////////////////////////////////////////// #
# // ARGS PARSE ////////////////////////////////////////////////////////////// #
# //////////////////////////////////////////////////////////////////////////// #

#set -xe

SCRIPTNAME=$(basename "$0")
SCRIPT_DIR=$(dirname "$0")
CONFIG_FILE=


print_help() {
cat << EOF

Usage: $SCRIPTNAME [options] [commands]

       options
       -------
       -h|--help)         get this help
       -v|--verbose)      show script source script
       -s|--service)      service name to reroute
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
        --debug)
            set -ex
            shift
            ;;
        -s|--service)
            SERVICE_NAME=$2
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

# sudo ip addr add 127.0.0.2 dev lo label lo:2

#SERVICE_NAME=mildsrv_web1
IPT_CHAIN=${SERVICE_NAME}

chain_remove () {
  sudo iptables -F $1
  sudo iptables -D FORWARD -j $1
  sudo iptables -X $1
  sudo iptables -t nat -F $1
  sudo iptables -t nat -D OUTPUT -m addrtype --dst-type LOCAL -j $1
  sudo iptables -t nat -D PREROUTING -m addrtype --dst-type LOCAL -j $1
  sudo iptables -t nat -X $1
}

chain_init () {
  sudo iptables -N $1
  id=$(sudo iptables --line-numbers -L FORWARD  | grep DOCKER-INGRESS | awk '{print $1; exit}')
  sudo iptables -I FORWARD $id -j $1
  # sudo iptables -A $1 -j RETURN

  sudo iptables -t nat -N $1
  sudo iptables -t nat -A PREROUTING -m addrtype --dst-type LOCAL -j $1
  sudo iptables -t nat -A OUTPUT -m addrtype --dst-type LOCAL -j $1
  # sudo iptables -t nat -A $1 -j RETURN
}


#
# Reroute selected ports to a fixed ip address
#
reroute_ports () {
  # utility internal functions
  inspect () { echo $(docker service inspect ${SERVICE_NAME} --format="$1"); }
  inspect_net () { echo $(docker network inspect docker_gwbridge --format="$1"); }
  length  () { var=$(inspect "{{range \$i := $1}}o{{end}}"); echo ${#var}; }
  reroute_ip=$(inspect '{{index .Spec.TaskTemplate.ContainerSpec.Labels "reroute.ip"}}')
  [ ${reroute_ip} ] || return 0;
  reroute_ports=$(inspect '{{index .Spec.TaskTemplate.ContainerSpec.Labels "reroute.ports"}}')
  sbox_ip=$(inspect_net '{{(index .Containers "ingress-sbox").IPv4Address}}')
  sbox_ip=${sbox_ip%/*} # remove mask
  target () { echo $(inspect "{{(index .Endpoint.Ports $1).TargetPort}}"); }
  published () { echo $(inspect "{{(index .Endpoint.Ports $1).PublishedPort}}"); }
  protocol () { echo $(inspect "{{(index .Endpoint.Ports $1).Protocol}}"); }
  dest_port=
  dest_prot=
  find_port () {
    port=$1
    len=$(length .Endpoint.Ports)
    for ((i=0;i<$len;i++)); do
      # echo "$i"
      if [ $(target $i) = $port ]; then
        dest_port=$(published $i);
        dest_prot=$(protocol $i);
        # echo "found $port -> $dest_port"
      fi
    done
  }

  chain_remove ${IPT_CHAIN}
  chain_init ${IPT_CHAIN}
  # LOOP PORTS
  for p in ${reroute_ports}; do
   p_src=${p#*:}
   p_dst=${p%:*}
   find_port ${p_src}
   echo "[reroute_DBG] $IPT_CHAIN: routing public ${reroute_ip}:${p_dst} " \
        "to $sbox_ip:$dest_port with protocol $dest_prot";
   sudo iptables -A ${IPT_CHAIN} \
            -p $dest_prot -m $dest_prot --dport ${p_dst} -j ACCEPT
   sudo iptables -A ${IPT_CHAIN} \
            -p $dest_prot -m state --state RELATED,ESTABLISHED \
            -m $dest_prot --sport ${p_dst} -j ACCEPT

   sudo iptables -t nat -A ${IPT_CHAIN} \
        -d $reroute_ip/32 -p ${dest_prot} --dport ${p_dst} \
        -j DNAT --to-destination ${sbox_ip}:${dest_port};
  done
  #
  sudo iptables -A ${IPT_CHAIN} -j RETURN
  sudo iptables -t nat -A ${IPT_CHAIN} -j RETURN

}


clear_ports () {
  chain_remove ${IPT_CHAIN}
}


# execute command
# echo $COMMAND ${@:1}
$COMMAND ${@:1}













