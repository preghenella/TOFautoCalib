#! /bin/bash

# init variables                                                                                                   
if [ "$1" = "" ] ; then
    echo "usage: TOFautoCalib.sh [period] [pass=cpass1_pass1] [startrun=0] [endun=0] [ocdb=local://OCDB]"
    exit 1
fi
period=$1
pass=$2
startrun=$3
endrun=$4
ocdb=$5

### init ###
if [ "$pass" = "" ]; then pass=cpass1_pass1; fi
if [ "$startrun" = "" ]; then startrun=0; fi
if [ "$endrun" = "" ]; then endrun=0; fi
if [ "$ocdb" = "" ]; then ocdb=local://OCDB; fi

year=$(echo "20"${period:3:2})
period_prefix=${period:0:5}
period_suffix=${period:5}

### splash ###
echo " --------------------------------------------"
echo " This is the TOF manual calibration automator"
echo " --------------------------------------------"
echo " You requested to calibrate period \"$period\" ($year)"
echo " using data from \"$pass\" reconstruction."
echo " I will process and produce the calibration objects"
echo " TOF/Calib/ParOffline, TOF/Calib/Problematics"
echo " that will be stored in OCDB folder"
echo " \"$ocdb\""
echo " with run-range validity [$startrun, $endrun]."
echo " --------------------------------------------"
echo " The process will start in 10 seconds from now"
echo " --------------------------------------------"
sleep 10

### copy data ###
chmod +x copyTOFcalibTree.sh
for (( i=0; i < ${#period_suffix}; i++ ))
do
    period_this=$(echo $period_prefix${period_suffix:$i:1})
    echo " >>> copying data from $period_this/$pass"
    ./copyTOFcalibTree.sh $year $period_this $pass
done

### check reference calibration
echo " >>> checking reference calibration"
rm -rf paroffline.list
for (( i=0; i < ${#period_suffix}; i++ ))
do
    period_this=$(echo $period_prefix${period_suffix:$i:1})
    grep "TOF/Calib/ParOffline" alice/data/$year/$period_this/*/$pass/rec.log | awk '{split($6,a,"?"); print a[1]}' >> paroffline.list
done
paroffline=`head -n1 paroffline.list`
if grep -v "^$paroffline$" paroffline.list
then
    echo "[ERROR] at least one run with unexpected reference calibration"
    exit 1
fi
echo " >>> reference calibration detected"
echo " $paroffline"

### create chain ###
echo " >>> creating chain"
rm -rf chain.list
for (( i=0; i < ${#period_suffix}; i++ ))
do
    period_this=$(echo $period_prefix${period_suffix:$i:1})
    ls alice/data/$year/$period_this/*/$pass/MergedTrees/*/TOFcalibTree.root >> chain.list
done
root -b -q "chainer.C(\"chain.list\", \"aodTree\", \"chain.root\")"

### run calibration ###
echo " >>> running calibration"
ln -sf TOFcalibAPI.C runCalib.C
root -b -q "runCalib.C(\"chain.root\")"

### update ParOffline ###
echo " >>> updating ParOffline"
ln -sf TOFcalibAPI.C updateParOfflineEntry.C
aliroot -b -q "updateParOfflineEntry.C(\"calibparams.root\", \"$paroffline\", $startrun, $endrun, \"$ocdb\")"

### create Problematics ###
echo " >>> creating Problematics"
ln -sf TOFcalibAPI.C problematicChannels.C
aliroot -b -q "problematicChannels.C(\"calibhistos.root\", 5., 100, 0., $startrun, $endrun, \"$ocdb\")"

### done ###
touch done
echo " >>> done"