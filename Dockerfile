# SPDX-FileCopyrightText: 2019 - 2025 Daniel Wolf <nephatrine@gmail.com>
#
# SPDX-License-Identifier: ISC

FROM code.nephatrine.net/nephnet/nxb-golang:latest AS builder

ARG GITEA_VERSION=v1.23.6
RUN git -C /root clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git
WORKDIR /root/gitea

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN make frontend && make backend

# ------------------------------

# hadolint ignore=DL3007
FROM code.nephatrine.net/nephnet/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

# hadolint ignore=DL3018
RUN usermod -p '*' -s /bin/bash guardian \
 && apk add --no-cache git git-lfs openssh-server openssh-keygen sqlite \
 && rm -rf /tmp/* /var/tmp/*

COPY --from=builder /root/gitea/gitea /usr/bin/
COPY --from=builder /root/gitea/custom/conf/app.example.ini /etc/gitea.ini.sample
COPY override /

EXPOSE 22/tcp 3000/tcp
