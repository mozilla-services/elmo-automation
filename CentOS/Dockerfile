FROM centos:7
RUN yum install -y gcc make readline-devel zlib-devel ncurses-devel openssl-devel sqlite-devel bzip2-devel libffi-devel mariadb mariadb-devel
WORKDIR /data/
# install python from source to /usr/local
ADD Python-2.7.12.tgz /data/
WORKDIR /data/Python-2.7.12
RUN ./configure
RUN make -j2
RUN make altinstall
# install pip
COPY get-pip.py /data/
WORKDIR /data/
RUN python2.7 get-pip.py
RUN pip install virtualenv supervisor
