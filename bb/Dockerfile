FROM local/elmo_base
ARG shares
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
COPY --chown=app:app ./bb/master-ball/ ./master-ball/
