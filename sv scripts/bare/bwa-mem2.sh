#!/bin/bash
#$ -N run_bwa-mem2_sam_bare
#$ -cwd
#$ -l s_vmem=32G

index=0
base="/home/yangxu/share"
input="$base/hg002/HG002_download"
data="$base/hg002/download"
newfolder=$base/bare-bwa-$index
mkdir $newfolder
start=$(date +%s)
while IFS= read -r line
do
        IFS=' '
        read -ra arr <<<"$line"
        echo "currently is working on $arr"
        /home/yangxu/bare_test/bwa/bwa-mem2 mem -t 20 $base/hg38/hg38.fa $data/${arr[1]}.fastq.gz $data/${arr[3]}.fastq.gz > $newfolder/${arr[1]}_${arr[3]}.sam
done < "$input"
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"
