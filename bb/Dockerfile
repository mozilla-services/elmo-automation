FROM pike/centos7-python2.7.12
# set up virtualenvs for master and slave
RUN pip install -U virtualenv
WORKDIR /data/
RUN virtualenv venv
COPY ./bb/master-ball/requirements.txt requirements.txt
RUN ./venv/bin/pip install -r requirements.txt
# uncomment if you want to test master compare-locales
# RUN pip install mercurial==4.2.2
# RUN ./venv/bin/pip install hg+https://hg.mozilla.org/l10n/compare-locales#egg=compare-locales
COPY ./bb/entrypoint.sh /data
