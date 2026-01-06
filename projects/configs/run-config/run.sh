#!/bin/bash

# -e stops on error
# -u stops on unset variable
# -o pipefail stops if any part of the pipeline fails
set -euo pipefail

RUN_PATH=$(dirname $0)

PURPLE='\033[0;35m'
RESET='\033[0m'

purple() { echo -e "${PURPLE}$1${RESET}" ; } #  -e  enable backslashes, like \n will output a new line

purple "Loading .env from: $PWD/../../.env\n"

set -a && . $PWD/../../.env 2> /dev/null && set +a    # load global .env
set -a && . .env 2> /dev/null && set +a                    # load local .env

# PATH=$PATH:$RUN_PATH                                       # enable calls like `mocha` instead of `node_modules/.bin/mocha`

# source $RUN_PATH/../@icetbr/run-config/common.sh
source $RUN_PATH/common.sh


"$@"
[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
