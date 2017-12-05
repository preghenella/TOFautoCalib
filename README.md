# TOF manual calibration automator

## Usage
`TOFautoCalib.sh [period] [pass=cpass1_pass1] [startrun=0] [endrun=0] [ocdb=local://OCDB]`  
`period`: string with LHC period(s) to be used as input for the calibration  
`pass`: reconstruction pass to be used as input for the calibration (default = `cpass1_pass1`)  
`startrun`: minimum of run-range validity (default = `0`)  
`startrun`: maximim of run-range validity (default = `0`)  
`ocdb`: string with the OCDB destination of the calibration objects (default = `local://OCDB`)

## Example #0
`TOFautoCalib.sh LHC17p`  
Performs the calibration of LHC period `LHC17p` with default `pass`, `startrun`, `endrun` and `ocdb` settings.
See the following examples for more details.

## Example #1
`TOFautoCalib.sh LHC17p cpass1_pass1 282351 282783 local://OCDB`  
Performs the calibration using the `cpass1_pass1` reconstructed data available from LHC period `LHC17p` of year `2017`.
The calibration objects will be stored in OCDB located in the local directory `OCDB`, with run-range validity `[282351, 282783]`.
The process needs to have write permission rights to store the calibration objects in the destination directory.

## Example #2
`TOFautoCalib.sh LHC17pqr cpass1_pass1 282351 282783 local://OCDB`  
Same as above, although it will use the data avilable from periods `LHC17p`, `LHC17q` and `LHC17r`.

## Example #3
`TOFautoCalib.sh LHC17pqr cpass1_pass1 282351 282783 alien://?folder=/alice/cern.ch/user/r/rpreghen/OCDB?user=rpreghen?se=ALICE::CERN::SE`  
Same as above, although the calibration objects will be stored in the OCDB located on Alien directory `/alice/cern.ch/user/r/rpreghen/OCDB`.
