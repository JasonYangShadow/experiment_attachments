#!/bin/bash

source ~/.bashrc
name=Linux-x86_64-lpmx
echo "---------------------------------------------"
echo "list all existing containers"
echo "command: $name list"
echo "---------------------------------------------"
read -p "press any key to continue"
$name list
read -p "press any key to continue"

echo "---------------------------------------------"
echo "list all exposed tools"
echo "command: ls -al ~/bin"
echo "---------------------------------------------"
read -p "press any key to continue"
ls -al ~/bin
read -p "press any key to continue"

echo "---------------------------------------------"
echo "list all data"
echo "command: ls -al ~/data"
echo "---------------------------------------------"
read -p "press any key to continue"
ls -al ~/data
read -p "press any key to continue"

echo "---------------------------------------------"
echo "we can create a new container by injecting existing bwa, samtools, gatk4"
echo "command: $name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/bwa=/bin/bwa:/home/vagrant/bin/samt
ools=/bin/samtools:/home/vagrant/bin/gatk4=/bin/gatk4 ubuntu:18.04 'cp /data/script.sh ~ && ~/script.sh'"
echo "---------------------------------------------"
read -p "press any key to continue"
$name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/bwa=/bin/bwa:/home/vagrant/bin/samtools=/bin/samto
ols:/home/vagrant/bin/gatk4=/bin/gatk4 ubuntu:18.04 "cp /data/script.sh ~ && ~/script.sh"
read -p "press any key to continue"

echo "---------------------------------------------"
echo "we can also create a new container by injecting existing minimap2, samtools, gatk3"
echo "command: $name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/minimap2=/bin/minimap2:/home/vagran
t/bin/samtools=/bin/samtools:/home/vagrant/bin/gatk3=/bin/gatk3 ubuntu:18.04 'cp /data/script.sh ~ && ~/script.sh'"
echo "---------------------------------------------"
read -p "press any key to continue"
$name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/minimap2=/bin/minimap2:/home/vagrant/bin/samtools=
/bin/samtools:/home/vagrant/bin/gatk3=/bin/gatk3 ubuntu:18.04 "cp /data/script.sh ~ && ~/script.sh"
read -p "press any key to continue"

echo "---------------------------------------------"
echo "we can also replace minimap2 with different version but still use the same script to do genome analysis"
echo "command: $name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/minimap2.10=/bin/minimap2:/home/vag
rant/bin/samtools=/bin/samtools:/home/vagrant/bin/gatk3=/bin/gatk3 ubuntu:18.04 'cp /data/script.sh ~ && ~/script.sh'"
echo "---------------------------------------------"
read -p "press any key to continue"
$name docker fastrun -v /home/vagrant/data:/data -m /home/vagrant/bin/minimap2.10=/bin/minimap2:/home/vagrant/bin/samtoo
ls=/bin/samtools:/home/vagrant/bin/gatk3=/bin/gatk3 ubuntu:18.04 "cp /data/script.sh ~ && ~/script.sh"
read -p "press any key to continue"
