#!/bin/bash
#$ -N run_samtools
#$ -cwd
#$ -l s_vmem=64G

source ~/.bashrc
index=1
base="/home/yangxu/share"
input="$base/hg002/HG002_download"
mkdir $base/bare-samtools-$index
start=$(date +%s)
while IFS= read -r line
do
        IFS=' '
        read -ra arr <<<"$line"
        echo "currently is working on $arr"
        samtools view -S -b $base/bare-bwa-$index/${arr[1]}_${arr[3]}.sam > $base/bare-samtools-$index/${arr[1]}_${arr[3]}.common.bam
        samtools collate -o $base/bare-samtools-$index/${arr[1]}_${arr[3]}.collate.bam $base/bare-samtools-$index/${arr[1]}_${arr[3]}.common.bam
        samtools fixmate -m $base/bare-samtools-$index/${arr[1]}_${arr[3]}.collate.bam $base/bare-samtools-$index/${arr[1]}_${arr[3]}.fixmate.bam
        samtools sort -o $base/bare-samtools-$index/${arr[1]}_${arr[3]}.sort.bam $base/bare-samtools-$index/${arr[1]}_${arr[3]}.fixmate.bam
        samtools markdup $base/bare-samtools-$index/${arr[1]}_${arr[3]}.sort.bam $base/bare-samtools-$index/${arr[1]}_${arr[3]}.markdup.bam
done < "$input"
samtools merge $base/bare-samtools-$index/final.bam $base/bare-samtools-$index/*.markdup.bam
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"
