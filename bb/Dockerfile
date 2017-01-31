FROM pike/centos7-python2.7.12
# set up virtualenvs for master and slave
WORKDIR /data/envs
RUN virtualenv @master
COPY ./bb/master-ball/requirements.txt @master/
RUN ./@master/bin/pip install -r @master/requirements.txt
RUN virtualenv @slave
COPY ./bb/slave-ball/requirements.txt @slave/
RUN ./@slave/bin/pip install -r @slave/requirements.txt

WORKDIR /data/master-ball/test-master
