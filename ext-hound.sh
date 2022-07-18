#!/bin/bash
IFS=''
if [ ! -d ./ext-hound-found ]
    then
        mkdir ext-hound-found
fi

echo "### finding files ###"
find . -type f > ./ext-hound-found/ext-hound-found.txt
echo "### done ###" 

cat ./ext-hound-found/ext-hound-found.txt | 
while read i
do
    fileName=$(echo ${i##*/})
    if [[ "$fileName" == *.* ]]; then
        echo "### filename is $fileName ###"
        fileExt=$(echo ${fileName##*.} | tr '[:upper:]' '[:lower:]')
        echo "### file is $i ###"
            if [ ! -d ./ext-hound-found/$fileExt ]
                then 
                    echo "### extension is $fileExt ###"
                    mkdir ./ext-hound-found/$fileExt
            fi
            if [ ! -h ./ext-hound-found/$fileExt/${i##*/} ]
                then 
                    echo "### path is $i ###"
                    ln -rs $i ./ext-hound-found/$fileExt
            fi
    else
        echo "### file is $i !!!(UNKNOWN EXTENSION)!!! ###"
        if [ ! -d ./ext-hound-found/unknown ]
            then
                mkdir ./ext-hound-found/unknown
        fi
        if [ ! -h ./ext-hound-found/unknown/${fileName} ]
            then
                echo "### path is $i ###"
                ln -rs $i ./ext-hound-found/unknown
        fi
    fi 
done < ./ext-hound-found/ext-hound-found.txt
