# Not using -slim, as Axel can't figure out where to get packages there.
FROM python:2.7.14-stretch

WORKDIR /app/
RUN groupadd --gid 10001 app && useradd -g app --uid 10001 --shell /usr/sbin/nologin app

# Install OS-level things
COPY ./base/set_up.sh /tmp/
RUN DEBIAN_FRONTEND=noninteractive /tmp/set_up.sh
