#!/usr/bin/env bash

set -e
set -u
set -o pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" && pwd -P )"
BLIBOX_PATH="$( cd "${SCRIPT_PATH}/../.." && pwd -P )"
# shellcheck disable=SC1090
. "${SCRIPT_PATH}/.lib.sh"


# -------------------------------------------------------------------------------------------------
# ENTRYPOINT
# -------------------------------------------------------------------------------------------------

run "rm -f ${BLIBOX_PATH}/.env"
run "cp ${BLIBOX_PATH}/env-example ${BLIBOX_PATH}/.env"
