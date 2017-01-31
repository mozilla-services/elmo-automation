FROM pike/centos7-python2.7.12
# create virtualenv for twisted and a10n
RUN virtualenv env
COPY ./a10n/a10n/requirements/automation.txt env/requirements.txt
RUN /data/env/bin/pip install -r env/requirements.txt
