#!/bin/bash
com="apt update && time apt install -y --no-install-recommends build-essential gcc clang python3 vim-gtk nodejs r-base libboost-all-dev"

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

		sudo docker run -it --rm ubuntu:16.04 /bin/bash -c "$com" | tee -a "docker.log"
	fi
}

t_lpmx(){
	if exists Linux-x86_64-lpmx;then
		echo "LPMX exists, let me run experiments on LPMX"

		Linux-x86_64-lpmx docker fastrun ubuntu:16.04 "$com" | tee -a "lpmx.log"
		Linux-x86_64-lpmx docker fastrun ubuntu:16.04-merge "$com" | tee -a "lpmx.merge.log"
	fi
}

t_singularity(){
	if exists singularity;then
		echo "Singularity exists, let me run experiments on Singularity"

		if [ -d ubuntu1604 ];then
			sudo rm -rf ubuntu1604
		fi
		
		sudo singularity build --sandbox ubuntu1604 library://ubuntu:16.04
		sudo singularity shell --writable ubuntu1604/ "$com" | tee -a "singularity.log"
		sudo rm -rf ubuntu1604
	fi
}

t_podman(){
	if exists podman;then
		echo "podman exists, let me run experiments on Podman"

		podman run -it --rm ubuntu:16.04 /bin/bash -c "$com" | tee -a "podman.log"
	fi
}

t_udocker(){
	if exists udocker;then
		echo "udocker exists, let me run experiments on uDocker"

		id="$(udocker create ubuntu:16.04)"
		udocker setup --execmode=F4 "$id"
		udocker run "$id" /bin/bash -c "$com" | tee "udocker.log"
		udocker rm "$id"
	fi
}

t_bare(){
	`$com` | tee "bare.log"
}

t_docker
t_podman
t_lpmx
t_singularity
t_udocker
t_bare