#!/bin/bash

K12="/data/E.Coli_K12.fasta"
FQ1="/data/SRR5383868_1.fastq"
FQ2="/data/SRR5383868_2.fastq"

if [ -x "$(command -v bwa)" ]; then
    echo "bwa index reference E. Coli K12 data"
    bwa "index $K12"

    echo "bwa align reads with reference E. Coli K12 data"
    bwa "mem -R '@RG\tID:K12\tSM:K12' $K12 $FQ1 $FQ2 > /data/E.Coli.bwa.raw.sam"
fi

if [ -x "$(command -v minimap2)" ]; then
    echo "minimap do alignment between reads and reference data"
    minimap2 "-K 80M -ax sr -R '@RG\tID:O104_H4\tSM:O104_H4' $K12 $FQ1 $FQ2 > /data/E.Coli.minimap2.raw.sam"
fi

if [ -x "$(command -v samtools)" ]; then
    echo "use samtools to process bam file"
    samtools "view -S -b /data/E.Coli.bwa.raw.sam > /data/bwa.bam"
    samtools "collate -o /data/bwa.collate.bam /data/bwa.bam"
    samtools "fixmate -m /data/bwa.collate.bam /data/bwa.fixmate.bam"
    samtools "sort -o /data/bwa.sort.bam /data/bwa.fixmate.bam"
    samtools "markdup /data/bwa.sort.bam /data/bwa.markdup.bam"
    samtools "index /data/bwa.markdup.bam"
    samtools "faidx $K12"
fi

if [ -x "$(command -v gatk4)" ]; then
    echo "use gatk for creation dictionary and do structural variation calling analysis"
    gatk4 "CreateSequenceDictionary -R $K12"
    gatk4 "HaplotypeCaller -R $K12 -I /data/bwa.markdup.bam -O /data/bwa_gatk4.vcf"
fi

if [ -x "$(command -v gatk3)" ]; then
    gatk3 "-T UnifiedGenotyper -R $K12 -I /data/bwa.markdup.bam -o /data/bwa_gatk3.vcf"
fi
~
