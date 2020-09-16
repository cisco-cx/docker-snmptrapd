#!/usr/bin/env bash

set -euo pipefail

/usr/local/bin/filebeat -c /app/filebeat.yml --strict.perms=false -e < /app/pipe_snmptrapd
