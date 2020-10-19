#!/usr/bin/env bash

set -euo pipefail

test -p /app/pipe_snmptrapd || mkfifo /app/pipe_snmptrapd
exec 3<> /app/pipe_snmptrapd

SNMPTRAPD_CONFIG_PATH=/app/conf/snmptrapd.conf

while ! test -f ${SNMPTRAPD_CONFIG_PATH}; do
    echo "Waiting for the config ${SNMPTRAPD_CONFIG_PATH}"
    sleep 1
done

/usr/bin/stdbuf -i0 -o0 -e0 /usr/sbin/snmptrapd -L o -f -n -c ${SNMPTRAPD_CONFIG_PATH} > /app/pipe_snmptrapd
