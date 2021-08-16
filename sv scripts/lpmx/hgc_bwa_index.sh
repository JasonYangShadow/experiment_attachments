#!/bin/bash
#$ -N run_bwa-mem2_index
#$ -cwd
#$ -l s_vmem=128G

source ~/.bashrc
time Linux-x86_64-lpmx docker fastrun -v /home/yangxu/share:/share dceoy/bwa-mem2:latest "bwa-mem2 index /share/hg38/hg38.fa"