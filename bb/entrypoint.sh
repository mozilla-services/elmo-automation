#!/bin/bash

cleanup_bots() {
    echo "should shut down buildbot"
    ./master-ball/scripts/buildbot stop master-ball/slave
    ./master-ball/scripts/buildbot stop master-ball/test-master
    echo "should have shut down buildbot"
    exit 0
}

trap "cleanup_bots" SIGTERM

# activate virtualenv
. /app/venv/bin/activate

cd /app/

# start master and slave
./master-ball/scripts/buildbot start master-ball/test-master
./master-ball/scripts/buildbot start master-ball/slave

echo "[hit enter key to exit] or run 'docker stop <container>'"
tail -F master-ball/*/twistd.log &
wait $!
