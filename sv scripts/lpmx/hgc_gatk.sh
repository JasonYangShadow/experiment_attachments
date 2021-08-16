#!/bin/bash
#$ -N run_gatk
#$ -cwd
#$ -l s_vmem=64G

source ~/.bashrc
time Linux-x86_64-lpmx docker fastrun -v /home/yangxu/share:/share broadinstitute/gatk:latest "cp /share/gatk.sh ~ && cd ~ && ./gatk.sh 4"