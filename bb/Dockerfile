FROM pike/centos7-python2.7.12
# set up virtualenvs for master and slave
WORKDIR /data/
RUN virtualenv venv
COPY ./bb/master-ball/requirements.txt master-requirements.txt
COPY ./bb/slave-ball/requirements.txt slave-requirements.txt
RUN ./venv/bin/pip install -r master-requirements.txt -r slave-requirements.txt
COPY ./bb/entrypoint.sh /data
