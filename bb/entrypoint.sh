#!/bin/bash

cleanup_bots() {
    ./slave-ball/scripts/buildbot stop slave-ball/slave
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
./slave-ball/scripts/buildbot start slave-ball/slave

echo "[hit enter key to exit] or run 'docker stop <container>'"
tail -F */*/twistd.log
