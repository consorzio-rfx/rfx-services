#!/bin/bash

set -e

# Options for starting Ganesha
: ${GANESHA_LOGFILE:="/dev/stdout"}
: ${GANESHA_CONFIGFILE:="/etc/ganesha/ganesha.conf"}
: ${GANESHA_OPTIONS:="-N NIV_EVENT"} # NIV_DEBUG
: ${GANESHA_EPOCH:=""}
: ${GANESHA_EXPORT_ID:="77"}
: ${GANESHA_EXPORT:="/export"}
: ${GANESHA_PSEUDO_PATH:="/"}
: ${GANESHA_ACCESS:="*"}
: ${GANESHA_ROOT_ACCESS:="*"}
: ${GANESHA_NFS_PROTOCOLS:="3,4"}
: ${GANESHA_TRANSPORTS:="UDP,TCP"}
: ${GANESHA_BOOTSTRAP_CONFIG:="yes"}

init_rpc() {
    echo "* Starting rpcbind"
    if [ ! -x /run/rpcbind ] ; then
        install -m755 -g 32 -o 32 -d /run/rpcbind
    fi
    rpcbind || return 0
    rpc.statd -L || return 0
    rpc.idmapd || return 0
    sleep 1
}

init_dbus() {
    echo "* Starting dbus"
    if [ ! -x /var/run/dbus ] ; then
        install -m755 -g 81 -o 81 -d /var/run/dbus
    fi
    rm -f /var/run/dbus/*
    rm -f /var/run/messagebus.pid
    dbus-uuidgen --ensure
    dbus-daemon --system --fork
    sleep 1
}


function bootstrap_config {
	echo "Bootstrapping Ganesha NFS config"
  cat <<END >${GANESHA_CONFIGFILE}
EXPORT
{
		# Export Id (mandatory, each EXPORT must have a unique Export_Id)
		Export_Id = ${GANESHA_EXPORT_ID};
		# Exported path (mandatory)
		Path = "${GANESHA_EXPORT}";
		# Pseudo Path (for NFS v4)
		Pseudo = "${GANESHA_PSEUDO_PATH}";
		# Access control options
		Access_Type = RW;
		Squash = No_Root_Squash;
		Root_Access = "${GANESHA_ROOT_ACCESS}";
		Access = "${GANESHA_ACCESS}";
		# NFS protocol options
		Transports = "${GANESHA_TRANSPORTS}";
		Protocols = "${GANESHA_NFS_PROTOCOLS}";
		SecType = "sys";
		# Exporting FSAL
		FSAL {
			Name = VFS;
		}
}
END
}

sleep 0.5

if [ ! -f ${GANESHA_EXPORT} ]; then
    mkdir -p "${GANESHA_EXPORT}"
fi

echo "Initializing Ganesha NFS server"
echo "=================================="
echo "export path: ${GANESHA_EXPORT}"
echo "=================================="

[ -f "${GANESHA_CONFIGFILE}" ] || bootstrap_config
init_rpc
init_dbus

echo "Generated NFS-Ganesha config:"
cat ${GANESHA_CONFIGFILE}

echo "* Starting Ganesha-NFS"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
exec /usr/bin/ganesha.nfsd -F -L ${GANESHA_LOGFILE} -f ${GANESHA_CONFIGFILE} ${GANESHA_OPTIONS}

