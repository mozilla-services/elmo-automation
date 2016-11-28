FROM python:2.7
WORKDIR /data/repos
ADD webdir.conf /data/
ADD etc/mercurial/hgrc /etc/mercurial/hgrc.d/mozilla.rc
RUN pip install mercurial==3.8
