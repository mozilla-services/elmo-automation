#!/bin/bash

HGPID=0

cleanup_bots() {
    echo "shutting down a10n"
    kill `cat twistd.pid`
    rm twistd.pid
    kill $HGPID
    exit 0
}

trap "cleanup_bots" SIGTERM

# activate virtualenv
. /data/env/bin/activate

cd /data/a10n

# twistd background automatically, logs to twistd.log
PYTHONPATH=. twistd get-pushes

./scripts/a10n hg > hg.log &
HGPID=$!

echo "[hit enter key to exit] or run 'docker stop <container>'"
tail -F *.log &
wait $!
