FROM local/elmo_base
ARG shares
ARG master=l10n-master
# set up virtualenvs for master and slave
RUN pip install -U virtualenv
RUN virtualenv venv
COPY ./bb/master-ball/requirements/ .
RUN ./venv/bin/pip install -r buildbot.txt
# uncomment if you want to test master compare-locales
# RUN ./venv/bin/pip install -U hg+https://hg.mozilla.org/l10n/compare-locales#egg=compare-locales
COPY ./bb/entrypoint.sh /app
RUN mkdir -p $shares
RUN chown app:app $shares
USER app
COPY --chown=app:app ./bb/master-ball/vendor-local/vendor.pth ./master-ball/vendor-local/
COPY --chown=app:app ./bb/master-ball/vendor-local/elmo/apps ./master-ball/vendor-local/elmo/apps
COPY --chown=app:app ./bb/master-ball/vendor-local/elmo/bb2mbdb ./master-ball/vendor-local/elmo/bb2mbdb
COPY --chown=app:app ./bb/master-ball/vendor-local/l10ninsp ./master-ball/vendor-local/l10ninsp
COPY --chown=app:app ./bb/master-ball/$master/master.cfg ./master-ball/l10n-master/
COPY --chown=app:app ./bb/master-ball/$master/l10nbuilds.ini ./master-ball/l10n-master/
COPY --chown=app:app ./bb/master-ball/$master/slaves.json ./master-ball/l10n-master/
COPY --chown=app:app ./bb/master-ball/scripts/buildbot ./master-ball/scripts/
COPY --chown=app:app ./bb/master-ball/scripts/update-master.py ./master-ball/scripts/
COPY --chown=app:app ./bb/master-ball/scripts/update-slave.py ./master-ball/scripts/
COPY --chown=app:app ./bb/master-ball/shared ./master-ball/shared
WORKDIR /app/master-ball
RUN /app/venv/bin/python scripts/buildbot create-master l10n-master
RUN /app/venv/bin/python scripts/update-master.py l10n-master
RUN /app/venv/bin/python scripts/buildbot create-slave slave localhost:9876 cs0 pwd
RUN /app/venv/bin/python scripts/update-slave.py slave
