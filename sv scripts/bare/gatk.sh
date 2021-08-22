#!/bin/bash
#$ -N run_gatk_bare
#$ -cwd
#$ -l s_vmem=64G

source ~/.bashrc

index=1
base=/home/yangxu/share
gatk=/home/yangxu/bare_test/gatk-4.2.1.0
mkdir $base/bare-gatk-$index
time samtools faidx $base/hg38/hg38.fa
time $gatk/gatk CreateSequenceDictionary -R $base/hg38/hg38.fa
time java -Xmx32G -jar $base/picard.jar AddOrReplaceReadGroups I=$base/bare-samtools-$index/final.bam O=$base/bare-gatk-$index/final.picard.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
time samtools index $base/bare-gatk-$index/final.picard.bam
time $gatk/gatk --java-options "-Xmx32G" HaplotypeCaller -R $base/hg38/hg38.fa -I $base/bare-gatk-$index/final.picard.bam -O $base/bare-gatk-$index/final.vcf