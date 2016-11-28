FROM python:2.7
ADD repos /repos
WORKDIR /repos
ADD etc/mercurial/hgrc /etc/mercurial/hgrc.d/mozilla.rc
RUN pip install mercurial==3.8
