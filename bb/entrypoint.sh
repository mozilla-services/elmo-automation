#!/bin/bash

cleanup_bots() {
    ./master-ball/scripts/buildbot stop master-ball/slave
    ./master-ball/scripts/buildbot stop master-ball/test-master
    kill $!
    exit 0
}

trap "cleanup_bots" SIGTERM

# activate virtualenv
. /data/venv/bin/activate

cd /data/

# start master and slave
./master-ball/scripts/buildbot start master-ball/test-master
./master-ball/scripts/buildbot start master-ball/slave

echo "[hit enter key to exit] or run 'docker stop <container>'"
tail -F master-ball/*/twistd.log
