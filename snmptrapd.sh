#!/usr/bin/env bash

set -euo pipefail

test -p /app/pipe_snmptrapd || mkfifo /app/pipe_snmptrapd
exec 3<> /app/pipe_snmptrapd

/usr/bin/stdbuf -i0 -o0 -e0 /usr/sbin/snmptrapd -L o -f -n -c /app/snmptrapd.conf > /app/pipe_snmptrapd
