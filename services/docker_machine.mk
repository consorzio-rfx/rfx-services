





## VIRTAULBOX ##
#  --virtualbox-boot2docker-url			VIRTUALBOX_BOOT2DOCKER_URL	Latest boot2docker url
#  --virtualbox-cpu-count				VIRTUALBOX_CPU_COUNT	1
#  --virtualbox-disk-size				VIRTUALBOX_DISK_SIZE	20000
#  --virtualbox-host-dns-resolver		VIRTUALBOX_HOST_DNS_RESOLVER	false
#  --virtualbox-hostonly-cidr			VIRTUALBOX_HOSTONLY_CIDR	192.168.99.1/24
#  --virtualbox-hostonly-nicpromisc		VIRTUALBOX_HOSTONLY_NIC_PROMISC	deny
#  --virtualbox-hostonly-nictype		VIRTUALBOX_HOSTONLY_NIC_TYPE	82540EM
#  --virtualbox-hostonly-no-dhcp		VIRTUALBOX_HOSTONLY_NO_DHCP	false
#  --virtualbox-import-boot2docker-vm	VIRTUALBOX_BOOT2DOCKER_IMPORT_VM	boot2docker-vm
#  --virtualbox-memory					VIRTUALBOX_MEMORY_SIZE	1024
#  --virtualbox-nat-nictype				VIRTUALBOX_NAT_NICTYPE	82540EM
#  --virtualbox-no-dns-proxy			VIRTUALBOX_NO_DNS_PROXY	false
#  --virtualbox-no-share				VIRTUALBOX_NO_SHARE	false
#  --virtualbox-no-vtx-check			VIRTUALBOX_NO_VTX_CHECK	false
#  --virtualbox-share-folder			VIRTUALBOX_SHARE_FOLDER	-
#  --virtualbox-ui-type					VIRTUALBOX_UI_TYPE	headless


export DOCKER_MACHINE
export DOCKER_MACHINES

ak__DIRECTORIES += .docker-build

machine-create: ##@@docker create a new machine
machine-create: ##@@docker get machine env

machine-%: DOCKER_MACHINE_DRIVER := $(or $($(MACHINE_NAME)_DRIVER),$(DOCKER_MACHINE_DRIVER),virtualbox)
machine-create:
	docker-machine create --driver $(DOCKER_MACHINE_DRIVER) $(MACHINE_NAME)

# machine-mount: mount_dir ?= $(abs_builddir)
# machine-mount:
# 	docker-machine ssh $(MACHINE_NAME) mkdir -p $(mount_dir); \
# 	docker-machine mount $(mount_dir) $(MACHINE_NAME):$(mount_dir)

# machine-umount: mount_dir ?= $(pwd)
# machine-umount:
# 	docker-machine mount -u $(MACHINE_NAME):$(mount_dir) $(mount_dir)

machine-%:
	docker-machine $* $(MACHINE_NAME)

machines:
	$(foreach m,$(DOCKER_MACHINES), $(MAKE) .docker-build/$(m)-env.sh MACHINE_NAME=$(m);)

machines-%:
	$(foreach m,$(DOCKER_MACHINES), $(MAKE) machine-$* MACHINE_NAME=$(m);)

.docker-build/$(MACHINE_NAME)-env.sh: | .docker-build
	$(MAKE) machine-create && docker-machine env $(MACHINE_NAME) > $@;

