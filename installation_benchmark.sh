#!/bin/bash
coms[0]="apt update && time apt install -y --no-install-recommends clang default-jre"
coms[1]="apt update && apt install -y --no-install-recommends wget && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && time sh ~/miniconda.sh -b -p ~/miniconda"
coms[2]="apt update && time apt install -y --no-install-recommends git ca-certificates autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev && cd ~ && git clone https://github.com/samtools/htslib.git && cd htslib &&autoconf && ./configure && time make && make install && cd .. & git clone https://github.com/samtools/samtools.git && cd samtools && autoconf -Wno-syntax && ./configure && time make"

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

		sudo docker run -it --rm ubuntu:16.04 /bin/bash -c "$1"
	fi
}

t_lpmx(){
	if exists Linux-x86_64-lpmx;then
		echo "LPMX exists, let me run experiments on LPMX"

		Linux-x86_64-lpmx docker fastrun ubuntu:16.04 "$1"
		Linux-x86_64-lpmx docker fastrun ubuntu:16.04-merge "$1"
	fi
}

t_singularity(){
	if exists singularity;then
		echo "Singularity exists, let me run experiments on Singularity"

		if [ -d ubuntu1604 ];then
			sudo rm -rf ubuntu1604
		fi
		
		sudo singularity build --sandbox ubuntu1604 library://ubuntu:16.04
		sudo singularity exec --writable ubuntu1604/ /bin/bash -c "$1"
		sudo rm -rf ubuntu1604
	fi
}

t_podman(){
	if exists podman;then
		echo "podman exists, let me run experiments on Podman"

		podman run -it --rm --network=host docker.io/ubuntu:16.04 /bin/bash -c "$1"
	fi
}

t_udocker(){
	if exists udocker;then
		echo "udocker exists, let me run experiments on uDocker"

		id="$(udocker create docker.io/ubuntu:16.04)"
		udocker setup --execmode=P2 "$id"
		udocker run "$id" /bin/bash -c "$1"
		udocker rm "$id"
	fi
}

t_bare(){
	sudo /bin/bash -c "$1"
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
	read -p "Press any key to continue"
	t_bare "$com" | tee -a "bare.log"
done
