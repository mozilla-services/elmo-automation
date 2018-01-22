FROM local/elmo_base
# create virtualenv for twisted and a10n
RUN pip install -U virtualenv
RUN virtualenv env
COPY ./a10n/a10n/requirements/automation.txt env/requirements.txt
RUN ./env/bin/pip install -r env/requirements.txt
COPY ./a10n/entrypoint.sh /app
