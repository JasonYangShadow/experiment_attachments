#!/bin/bash
#$ -N run_bwa-mem2_sam
#$ -cwd
#$ -l s_vmem=32G

source ~/.bashrc
time Linux-x86_64-lpmx docker fastrun -v /home/yangxu/share:/share dceoy/bwa-mem2:latest "cp /share/bwa-mem2.sh ~ && cd ~ && ./bwa-mem2.sh 4"