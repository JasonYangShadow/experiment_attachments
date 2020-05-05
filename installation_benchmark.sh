#!/bin/bash
com="apt update && time apt install -y --no-install-recommends build-essential gcc clang python3 vim-gtk nodejs libboost-all-dev ruby"

exists(){
	if [ -x "$(command -v $1)" ];then
		return 0
	else
		return 1
	fi	
}

t_docker(){
	if exists docker; then
		#list existing containers
		echo "Docker exists, let me run experiments on Docker"
		#remove previous conatiners
		containers="$(sudo docker ps -aq)"
		if [ ! -z "$containers" ];then
			sudo docker rm $(sudo docker ps -aq)
		fi

		sudo docker run -it --rm ubuntu:16.04 /bin/bash -c "$com"
	fi
}

t_lpmx(){
	if exists Linux-x86_64-lpmx;then
		echo "LPMX exists, let me run experiments on LPMX"

		Linux-x86_64-lpmx docker fastrun ubuntu:16.04 "$com"
		Linux-x86_64-lpmx docker fastrun ubuntu:16.04-merge "$com"
	fi
}

t_singularity(){
	if exists singularity;then
		echo "Singularity exists, let me run experiments on Singularity"

		if [ -d ubuntu1604 ];then
			sudo rm -rf ubuntu1604
		fi
		
		sudo singularity build --sandbox ubuntu1604 library://ubuntu:16.04
		sudo singularity exec --writable ubuntu1604/ /bin/bash -c "$com"
		sudo rm -rf ubuntu1604
	fi
}

t_podman(){
	if exists podman;then
		echo "podman exists, let me run experiments on Podman"

		podman run -it --rm --network=host docker.io/ubuntu:16.04 /bin/bash -c "$com"
	fi
}

t_udocker(){
	if exists udocker;then
		echo "udocker exists, let me run experiments on uDocker"

		id="$(udocker create docker.io/ubuntu:16.04)"
		udocker setup --execmode=P2 "$id"
		udocker run "$id" /bin/bash -c "$com"
		udocker rm "$id"
	fi
}

t_bare(){
	`$com`
}

t_lpmx
t_docker
t_podman
t_singularity
t_udocker
t_bare
