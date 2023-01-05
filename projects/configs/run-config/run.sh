#!/bin/bash

# echo $PWD
# source ../@icetbr/run-config/common.sh
# source ./common.sh
RUN_PATH=$(dirname $0)
# echo $RUN_PATH
source $RUN_PATH/../@icetbr/run-config/common.sh

"$@"

