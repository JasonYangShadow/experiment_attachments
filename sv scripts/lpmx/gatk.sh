#!/bin/bash
mkdir /share/gatk-$1
time samtools faidx /share/hg38/hg38.fa
time /gatk/gatk CreateSequenceDictionary -R /share/hg38/hg38.fa
cp /share/picard.jar /root/picard.jar
time java -Xmx4G -jar /root/picard.jar AddOrReplaceReadGroups I=/share/samtools-$1/final.bam O=/share/gatk-$1/final.picard.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
time samtools index /share/gatk-$1/final.picard.bam
time /gatk/gatk HaplotypeCaller -R /share/hg38/hg38.fa -I /share/gatk-$1/final.picard.bam -O /share/gatk-$1/final.vcf