#!/bin/bash

cleanup_bots() {
    kill `cat twistd.pid`
    kill $!
    exit 0
}

trap "cleanup_bots" SIGTERM

# activate virtualenv
. /data/env/bin/activate

cd /data/a10n

# twistd background automatically, logs to twistd.log
twistd get-pushes

./scripts/a10n hg > hg.log &

echo "[hit enter key to exit] or run 'docker stop <container>'"
tail -F *.log
