#!/bin/bash

# -e stops on error
# -u stops on unset variable
# -o pipefail stops if any part of the pipeline fails
set -euo pipefail

RUN_PATH=$(dirname $0)

set -a && . $RUN_PATH/../../.env 2> /dev/null && set +a    # load global .env
set -a && . .env 2> /dev/null && set +a                    # load local .env

PATH=$PATH:$RUN_PATH                                       # enable calls like `mocha` instead of `node_modules/.bin/mocha`

source $RUN_PATH/../@icetbr/run-config/common.sh


"$@"
[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
