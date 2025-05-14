# SPDX-FileCopyrightText: 2019-2025 Daniel Wolf <nephatrine@gmail.com>
# SPDX-License-Identifier: ISC

# hadolint global ignore=DL3007,DL3018

FROM code.nephatrine.net/nephnet/nxb-golang:latest AS builder

ARG GITEA_VERSION=v1.23.7
RUN git -C /root clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git
WORKDIR /root/gitea

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN make frontend && make backend

FROM code.nephatrine.net/nephnet/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN usermod -p '*' -s /bin/bash guardian \
 && apk add --no-cache git git-lfs openssh-server openssh-keygen sqlite \
 && rm -rf /tmp/* /var/tmp/*

COPY --from=builder /root/gitea/gitea /usr/bin/
COPY --from=builder /root/gitea/custom/conf/app.example.ini /etc/gitea.ini.sample
COPY override /

EXPOSE 22/tcp 3000/tcp
