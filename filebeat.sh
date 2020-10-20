#!/usr/bin/env bash

set -euo pipefail

# wait for snmptrapd process
while ! pidof snmptrapd; do
    echo "Wating for snmptrapd process"
    sleep 1s
done

/usr/local/bin/filebeat -c /app/filebeat.yml --strict.perms=false -e < /app/pipe_snmptrapd
