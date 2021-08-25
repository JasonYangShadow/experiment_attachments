#!/bin/bash
#$ -N run_samtools
#$ -cwd
#$ -l s_vmem=64G

source ~/.bashrc
time Linux-x86_64-lpmx docker fastrun -v /home/yangxu/share=/share:/tmp=/tmp staphb/samtools:1.13 "cp /share/samtools.sh ~ && cd ~ && ./samtools.sh 0"