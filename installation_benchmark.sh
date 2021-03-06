#!/bin/bash
coms[0]="apt update && time apt install -y --no-install-recommends default-jre gcc g++ python3 perl ruby"
coms[1]="apt update && apt install -y --no-install-recommends git ca-certificates autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev && cd ~ && git clone https://github.com/samtools/htslib.git && cd htslib && autoheader && autoconf && ./configure && time make && make install && cd ~ && git clone https://github.com/samtools/samtools.git && cd samtools && autoheader && autoconf -Wno-syntax && ./configure && time make"

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
		sudo docker version
		#remove previous conatiners
		containers="$(sudo docker ps -aq)"
		if [ ! -z "$containers" ];then
			sudo docker rm $(sudo docker ps -aq)
		fi

		sudo docker run -it --rm ubuntu:18.04 /bin/bash -c "$1"
	fi
}

t_lpmx(){
	if exists Linux-x86_64-lpmx;then
		echo "LPMX exists, let me run experiments on LPMX"
		Linux-x86_64-lpmx version	
		echo "**************** I am testing installing software on 5 layers(Docker Image)***************************"
		Linux-x86_64-lpmx docker fastrun ubuntu:18.04 "$1"
		echo "**************** I am testing installing software on 2 layers(Merged Image)***************************"
		Linux-x86_64-lpmx docker fastrun ubuntu:18.04-merge "$1"
	fi
}

t_singularity(){
	if exists singularity;then
		echo "Singularity exists, let me run experiments on Singularity"

		if [ -d ubuntu1804 ];then
			sudo rm -rf ubuntu1804
		fi
		singularity version	
		sudo singularity build --sandbox ubuntu1804 library://ubuntu:18.04
		sudo singularity exec --writable ubuntu1804/ /bin/bash -c "$1"
		sudo rm -rf ubuntu1804
	fi
}

t_podman(){
	if exists podman;then
		echo "podman exists, let me run experiments on Podman"
		podman version
		podman run -it --rm --network=host docker.io/ubuntu:18.04 /bin/bash -c "$1"
	fi
}

t_udocker(){
	if exists udocker;then
		echo "udocker exists, let me run experiments on uDocker"
		udocker version
		id="$(udocker create docker.io/ubuntu:18.04)"
		udocker setup --execmode=P2 "$id"
		udocker run "$id" /bin/bash -c "$1"
		udocker rm "$id"
	fi
}

for com in "${coms[@]}";do
	echo "start executing command: $com"
	t_lpmx "$com" | tee -a "lpmx.log"
	read -p "Press any key to continue"
	t_docker "$com" | tee -a "docker.log"
	read -p "Press any key to continue"
	t_podman "$com" | tee -a "podman.log"
	read -p "Press any key to continue"
	t_singularity "$com" | tee -a "singularity.log"
	read -p "Press any key to continue"
	t_udocker "$com" | tee -a "udocker.log"
done
