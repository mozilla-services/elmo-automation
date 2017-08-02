FROM pike/centos7-python2.7.12
# set up virtualenvs for master and slave
RUN pip install -U virtualenv
WORKDIR /data/
RUN virtualenv venv
COPY ./bb/master-ball/requirements.txt requirements.txt
RUN ./venv/bin/pip install -r requirements.txt
COPY ./bb/entrypoint.sh /data
