#!/bin/bash
set -xeuo pipefail

export SUPERVISORCONFIG=${SUPERVISORCONFIG:-/etc/supervisor/supervisord.conf}
export SUPERVISORLOGLEVEL=${SUPERVISORLOGLEVEL:-info}

exec /usr/bin/supervisord \
  --configuration=${SUPERVISORCONFIG} \
  --nodaemon \
  --user=root \
  --loglevel=${SUPERVISORLOGLEVEL}
# TODO: Run as user app
#  --user=1000 \
