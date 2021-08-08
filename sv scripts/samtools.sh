#!/bin/bash

input="/share/hg002/HG002_download"
mkdir /share/samtools-$1
start=$(date +%s)
while IFS= read -r line
do
        IFS=' '
        read -ra arr <<<"$line"
        echo "currently is working on $arr"
        samtools view -S -b /share/bwa-$1/${arr[1]}_${arr[3]}.sam > /share/samtools-$1/${arr[1]}_${arr[3]}.common.bam
        samtools collate -o /share/samtools-$1/${arr[1]}_${arr[3]}.collate.bam /share/samtools-$1/${arr[1]}_${arr[3]}.common.bam
        samtools fixmate -m /share/samtools-$1/${arr[1]}_${arr[3]}.collate.bam /share/samtools-$1/${arr[1]}_${arr[3]}.fixmate.bam
        samtools sort -o /share/samtools-$1/${arr[1]}_${arr[3]}.sort.bam /share/samtools-$1/${arr[1]}_${arr[3]}.fixmate.bam
        samtools markdup /share/samtools-$1/${arr[1]}_${arr[3]}.sort.bam /share/samtools-$1/${arr[1]}_${arr[3]}.markdup.bam
done < "$input"
samtools merge final.bam /share/samtools-$1/*.markdup.bam
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"

######################################### V2
#!/bin/bash
#$ -N run_samtools
#$ -cwd
#$ -l s_vmem=16G

source ~/.bashrc
index=4
input="/home/yangxu/share/hg002/HG002_download"
mkdir /home/yangxu/share/samtools-$index
start=$(date +%s)
while IFS= read -r line
do
        IFS=' '
        read -ra arr <<<"$line"
        echo "currently is working on $arr"
        samtools "view -S -b /share/bwa-$index/${arr[1]}_${arr[3]}.sam > /share/samtools-$index/${arr[1]}_${arr[3]}.common.bam"
        samtools "collate -o /share/samtools-$index/${arr[1]}_${arr[3]}.collate.bam /share/samtools-$index/${arr[1]}_${arr[3]}.common.bam"
        samtools "fixmate -m /share/samtools-$index/${arr[1]}_${arr[3]}.collate.bam /share/samtools-$index/${arr[1]}_${arr[3]}.fixmate.bam"
        samtools "sort -o /share/samtools-$index/${arr[1]}_${arr[3]}.sort.bam /share/samtools-$index/${arr[1]}_${arr[3]}.fixmate.bam"
        samtools "markdup /share/samtools-$index/${arr[1]}_${arr[3]}.sort.bam /share/samtools-$index/${arr[1]}_${arr[3]}.markdup.bam"
done < "$input"
samtools "merge final.bam /share/samtools-$index/*.markdup.bam"
end=$(date +%s)
echo "Elapsed Time: $(($end-$start)) seconds"