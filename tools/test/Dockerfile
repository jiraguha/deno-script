ARG deno_version

FROM alpine:latest as builder-bats
ARG bats_version
RUN apk --update add --no-cache git less openssh curl && \
    rm -rf /var/lib/apt/lists/*
RUN cd /root && apk add --virtual .download --no-cache curl \
        && curl -fsSL "https://github.com/bats-core/bats-core/archive/v${bats_version}.zip" \
        --output bats-core.zip \
        && unzip bats-core.zip\
        && rm bats-core.zip \
        && mv bats-core-${bats_version} bats-core

FROM hayd/alpine-deno:${deno_version}

COPY --from=builder-bats /root/bats-core /opt/bats/

RUN apk add --no-cache bash

RUN ln -s /opt/bats/bin/bats /usr/local/bin/bats

ENTRYPOINT ["bash", "bats"]
