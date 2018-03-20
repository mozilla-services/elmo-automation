# Not using -slim, as Axel can't figure out where to get packages there.
FROM python:2.7.14-stretch

ENV TINI_VERSION v0.17.0
RUN set -x && \
    curl -Lo /tini "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" && \
    curl -Lo /tmp/tini.asc "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    for server in $(shuf -e ha.pool.sks-keyservers.net \
                            hkp://p80.pool.sks-keyservers.net:80 \
                            keyserver.ubuntu.com \
                            hkp://keyserver.ubuntu.com:80 \
                            pgp.mit.edu) ; do \
        echo trying $server ; \
        gpg --keyserver "$server" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || : ; \
    done && \
    gpg --batch --verify /tmp/tini.asc /tini && \
    gpgconf --kill gpg-agent && \
    rm -r "$GNUPGHOME" /tmp/tini.asc && \
    chmod +x /tini

WORKDIR /app/
RUN groupadd --gid 10001 app && useradd -g app --uid 10001 --shell /usr/sbin/nologin app

# Install OS-level things
COPY ./base/set_up.sh /tmp/
RUN DEBIAN_FRONTEND=noninteractive /tmp/set_up.sh

ENTRYPOINT ["/tini", "--"]
CMD ["/app/entrypoint.sh"]
