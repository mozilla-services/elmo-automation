Elmo Automation
===============

This repository contains the automation behind https://l10n.mozilla.org, aka Elmo. It's built on top of docker compose, and is deployed on SCL3 and AWS.

Please use bugzilla to [file issues/bugs]([https://bugzilla.mozilla.org/enter_bug.cgi?product=Localization%20Infrastructure%20and%20Tools&component=Automation).

Find more information on Elmo itself in [its repo](https://github.com/mozilla/elmo/).

Volumes
-------
There's a shared data volume between some of the containers below. It's used to cache bare repository data. That can be used in containers to access that, or to `hg share` repositories cheaply to local disk.

Containers
----------
For testing only, there's an `hg` container. It mocks https://hg.mozilla.org/, in a rather naive way, though. As we test the automation, this is where the data flow starts.

### `hg-poller`
This container scrapes `hg` for new pushes, by continuously loading the `json-pushes` endpoint for each known repository. It feeds newly found pushes to `rabbitmq`.

### `a10n-hg-worker`
This container observes the queue that `hg-poller` writes to, and syncronizes the new push data with the `elmo` database. To do so, it also updates the shared clones in order to do so.

### `bb`
This container runs `buildbot 0.7.x`. It runs the master, which is responsible for polling the `elmo` database for new changes, schedule *builds*, and gather status and logs. The status is mirrored in the `elmo` database.

It also runs the slave, which is doing the actual work. The *build* steps contain

* Ensure the Index and Mapping on `es`
* For each repository in the build
  * Ensure an hg share
  * Update the share to the specified revision
* Run compare-locales

The slave stores a summary of the compare-locales result in the `elmo` database, and uploads the details as a JSON blob to `es`.

### `es` and `rabbitmq`
These two are stock instances of ElasticSearch and RabbitMQ.
