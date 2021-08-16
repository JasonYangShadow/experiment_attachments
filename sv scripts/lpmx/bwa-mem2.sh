#!/bin/bash

input="/share/hg002/HG002_download"
mkdir /share/bwa-$1
start=$(date +%s)
while IFS= read -r line
do
        IFS=' '
        read -ra arr <<<"$line"
        echo "currently is working on $arr"
        bwa-mem2 mem /share/hg38/hg38.fa /share/hg002/download/${arr[1]}.fastq.gz /share/hg002/download/${arr[3]}.fastq.gz > /share/bwa-$1/${arr[1]}_${arr[3]}.sam
done < "$input"
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"