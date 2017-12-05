# TOF manual calibration automator

## Usage
`TOFautoCalib.sh [year] [period] [pass] [startrun] [endrun] [ocdb]`

## Example #1
`TOFautoCalib.sh 2017 LHC17p cpass1_pass1 282351 282783 local://OCDB`

Performs the calibration using the `cpass1_pass1` reconstructed data available from LHC period `LHC17p` of year `2017`.
The calibration objects will be stored in OCDB located in the local directory `OCDB`, with run-range validity `[282351, 282783]`.
The process needs to have write permission rights to store the calibration objects in the destination directory.

## Example #2
`TOFautoCalib.sh 2017 LHC17pqr cpass1_pass1 282351 282783 local://OCDB`

Same as above, although it will use the data avilable from periods `LHC17p`, `LHC17q` and `LHC17r`.

## Example #3
`TOFautoCalib.sh 2017 LHC17pqr cpass1_pass1 282351 282783 alien://?folder=/alice/cern.ch/user/r/rpreghen/OCDB?user=rpreghen?se=ALICE::CERN::SE`

Same as above, although the calibration objects will be stored in the OCDB located on Alien directory `/alice/cern.ch/user/r/rpreghen/OCDB`.
