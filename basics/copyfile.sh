#!/bin/bash
##################################################################
#####  Purpose: create a  backup of the file and use name
#####  as "originalfilename+date" for the backup file
#################################################################


set -x #debug mode
set -e #exit the script when there is an error
set -o pipefail #This is needed when pipe is used in the code and to ensure that pipe command last result is valid/invalid


datevalue=$(date +"%Y-%m-%d_%H:%M:%S")

originalfilename="originalfile.txt"
backupfilename=${originalfilename}_${datevalue}
echo "backupfilename is: $backupfilename"
cp $originalfilename $backupfilename