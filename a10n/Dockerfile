FROM local/elmo_base
# create virtualenv for twisted and a10n
RUN pip install -U virtualenv
RUN virtualenv env
COPY ./requirements/automation.txt env/requirements.txt
RUN ./env/bin/pip install -r env/requirements.txt
COPY version.json /app/
USER app
WORKDIR /app/a10n
COPY --chown=app:app ./vendor-local/vendor.pth ./vendor-local/
COPY --chown=app:app ./vendor-local/elmo/apps ./vendor-local/elmo/apps
COPY --chown=app:app ./a10n/ ./a10n
COPY --chown=app:app ./scripts/a10n ./scripts/a10n
COPY --chown=app:app ./twisted/ ./twisted
