#! /bin/bash

# init variables                                                                                                   
if [ "$1" = "" ] || [ "$2" = "" ]; then
    echo "usage: copyTOFcalibTree.sh [year] [period] [pass]"
    exit 1
fi
year=$1
period=$2
pass=$3

for I in `alien_find /alice/data/$year/$period $pass/MergedTrees | grep TOFcalibTree.root`; do
    
#    while [ $(ps -ef | grep alien_cp | wc -l) -ge 20 ]; do
#        sleep 10s;
#    done

    dir=./${I%TOFcalibTree.root}
    mkdir -p $dir
    alien_cp alien:$I $dir/TOFcalibTree.root #& 

done

for I in `alien_find /alice/data/$year/$period $pass/rec.log | grep rec.log`; do

#    while [ $(ps -ef | grep alien_cp | wc -l) -ge 20 ]; do
#        sleep 10s;
#    done

    dir=./${I%rec.log}
    mkdir -p $dir
    alien_cp alien:$I $dir/rec.log #& 

done

#wait