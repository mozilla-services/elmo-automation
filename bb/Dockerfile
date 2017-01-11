FROM centos:7
RUN yum install -y gcc make readline-devel zlib-devel ncurses-devel openssl-devel sqlite-devel bzip2-devel libffi-devel mariadb mariadb-devel
WORKDIR /data/
# install python from source to /usr/local
ADD blobs/Python-2.7.12.tgz /data/
WORKDIR /data/Python-2.7.12
RUN ./configure
RUN make -j2
RUN make altinstall
# install pip
COPY blobs/get-pip.py /data/
WORKDIR /data/
RUN python2.7 get-pip.py
RUN pip install virtualenv supervisor
# set up virtualenvs for master and slave
WORKDIR /data/envs
RUN virtualenv @master
COPY ./bb/master-ball/requirements.txt @master/
RUN ./@master/bin/pip install -r @master/requirements.txt
RUN virtualenv @slave
COPY ./bb/slave-ball/requirements.txt @slave/
RUN ./@slave/bin/pip install -r @slave/requirements.txt

WORKDIR /data/master-ball/test-master
