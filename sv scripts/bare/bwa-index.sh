#!/bin/bash
#$ -N run_bwa-mem2_index_bare
#$ -cwd
#$ -l s_vmem=128G

time /home/yangxu/bare_test/bwa/bwa-mem2 index /home/yangxu/share/hg38/hg38.fa