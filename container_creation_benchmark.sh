#!/bin/bash
END=10
coms[0]="exit"

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

                sudo docker rmi ubuntu:16.04
                sudo docker pull ubuntu:16.04
                startTime=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                sudo docker run -it --rm ubuntu:16.04 /bin/bash -c "$1"
                done
                endTime=$(date +%s%3N);
                totalTime=$(($endTime-$startTime));
                echo "docker time elapse+ $totalTime ms"
        fi
}

t_lpmx(){
        if exists Linux-x86_64-lpmx;then
                echo "LPMX exists, let me run experiments on LPMX"
                Linux-x86_64-lpmx version
                echo "**************** I am testing on 5 layers(Docker Image)***************************"
                startTime=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                Linux-x86_64-lpmx docker fastrun ubuntu:16.04 "$1"
                done
                endTime=$(date +%s%3N);
                echo $endTime $startTime
                totalTime=$(($endTime-$startTime));
                echo "lpmx 5 layers time elapse+ $totalTime ms"
                echo "**************** I am testing on 2 layers(Merged Image)***************************"

                startTime1=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                Linux-x86_64-lpmx docker fastrun ubuntu:16.04-merge "$1"
                done
                endTime1=$(date +%s%3N);
                totalTime1=$(($endTime-$startTime));
                echo "lpmx 2 layers time elapse+ $totalTime1 ms"
        fi
}

t_singularity(){
        if exists singularity;then
                echo "Singularity exists, let me run experiments on Singularity"

                if [ -f ubuntu1604.sif ];then
                        sudo rm -rf ubuntu1604.sif
                fi
                singularity version
                sudo singularity build ubuntu1604.sif library://ubuntu:16.04

                startTime=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                singularity exec ubuntu1604.sif /bin/bash -c "$1"
                done
                endTime=$(date +%s%3N);
                totalTime=$(($endTime-$startTime));
                echo "singularity time elapse+ $totalTime ms"
                sudo rm -rf ubuntu1604.sif
        fi
}

t_podman(){
        if exists podman;then
                echo "podman exists, let me run experiments on Podman"
                podman version

                sudo podman rmi docker.io/ubuntu:16.04
                sudo podman pull docker.io/ubuntu:16.04
                startTime=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                sudo podman run -it --rm --network=host docker.io/ubuntu:16.04 /bin/bash -c "$1"
                done
                endTime=$(date +%s%3N);
                totalTime=$(($endTime-$startTime));
                echo "podman time elapse+ $totalTime ms"
        fi
}

t_udocker(){
        if exists udocker;then
                echo "udocker exists, let me run experiments on uDocker"
                udocker version

                startTime=$(date +%s%3N);
                for (( i =1; i<= $END; i++));
                do
                id="$(udocker create docker.io/ubuntu:16.04)"
                udocker setup --execmode=P2 "$id"
                udocker run "$id" /bin/bash -c "$1"
                udocker rm "$id"
                done
                endTime=$(date +%s%3N);
                totalTime=$(($endTime-$startTime));
                echo "udocker time elapse+ $totalTime ms"
        fi
}

for com in "${coms[@]}";do
        echo "start executing command: $com"
        t_lpmx "$com" | tee -a "lpmx.log"
        read -p "Press any key to continue"
        t_docker "$com" | tee -a "docker.log"
        read -p "Press any key to continue"
        t_singularity "$com" | tee -a "singularity.log"
        read -p "Press any key to continue"
        t_udocker "$com" | tee -a "udocker.log"
        read -p "Press any key to continue"
        t_podman "$com" | tee -a "podman.log"
        read -p "Press any key to continue"
done
