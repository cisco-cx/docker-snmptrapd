#!/usr/bin/env bash

set -euo pipefail

/usr/bin/stdbuf -i0 -o0 -e0 \
  /usr/sbin/snmptrapd -L o -f -n -c /app/snmptrapd.conf \
    | /usr/local/bin/filebeat -c /app/filebeat.yml --strict.perms=false -e
