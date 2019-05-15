FROM python:2.7
WORKDIR /app
ADD webdir.conf /app/
ADD etc/mercurial/hgrc /etc/mercurial/hgrc.d/mozilla.rc
RUN pip install mercurial==4.9.1
