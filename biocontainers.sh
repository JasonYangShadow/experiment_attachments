#!/bin/bash

exists(){
    if [ -x "$(command -v $1)" ];then
        return 0
    else
        return 1
    fi
}

if ! exists git;then
    echo "git is required, please install git first"
    exit -1
fi

if [ ! -d "experiment_attachments" ];then
    git clone https://github.com/JasonYangShadow/experiment_attachments.git
fi
cd experiment_attachments

if [ ! -d "bioconda-recipes" ];then
    git clone https://github.com/bioconda/bioconda-recipes.git
fi

if [ ! -f "biocontainers" ];then
    echo "biocontainers file does not exist"
    exit -1
fi

if [ ! -d "bioconda-recipes" ];then
    echo "bioconda-recipes does not exist"
    exit -1
fi

#read line by line
while IFS= read -r line;do
    #Docker image name
    echo "starts process $line"
    #IFS=':'
    #while read -r fullname tag;do
    #    name="${fullname:11}"
    #    echo "$name $tag"
    #done < "$line"
done < biocontainers
