#!/bin/bash
#$ -N run_samtools
#$ -cwd
#$ -l s_vmem=64G

source ~/.bashrc
Linux-x86_64-lpmx docker fastrun -v /home/yangxu/share=/share samtools:1.13 "cp /share/samtools.sh /root && ./root/samtools.sh 4"