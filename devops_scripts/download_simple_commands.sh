#!/bin/bash

###########################################################################
# download an error file which is in github or s3 or azure blob
# display error lines from log file "sample_Error_file.log"
# Print only lines having ERROR keyword
set -x
set -e
set -o

#get the file using curl command and use grep to extract ERROR
#curl https://github.com/nayakwadi/linux-scripts/blob/main/basics/sample_error_file.log | grep ERROR

#get the file using wget command and save it as loacllog file, read ERROR lines from it
wget https://github.com/nayakwadi/linux-scripts/blob/main/basics/sample_error_file.log "local_error.log"

cat local_error.log | grep ERROR