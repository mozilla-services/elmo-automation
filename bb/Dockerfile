FROM centos:7
RUN yum install -y gcc make readline-devel zlib-devel ncurses-devel openssl-devel sqlite-devel bzip2-devel mariadb mariadb-devel
WORKDIR /data/
# install python from source to /usr/local
COPY blobs/Python-2.7.12.tgz /data/
RUN tar xzf Python-2.7.12.tgz
WORKDIR /data/Python-2.7.12
RUN ./configure
RUN make -j2
RUN make altinstall
# install pip
COPY blobs/get-pip.py /data/
WORKDIR /data/
RUN python2.7 get-pip.py
RUN pip install virtualenv
# set up master-ball
WORKDIR /data/master-ball
RUN virtualenv @master
RUN ./@master/bin/pip install -r requirements.txt
RUN ./@master/bin/python scripts/buildbot create-master test-master 
WORKDIR /data/slave-ball
RUN virtualenv @slave
RUN ./@slave/bin/pip install -r requirements.txt
RUN ./@slave/bin/python scripts/buildbot create-slave slave localhost:9876 cs0 pwd
RUN ./@slave/bin/python scripts/update-slave.py slave
