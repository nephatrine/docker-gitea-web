FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL TOOLS ======" \
 && apk add --no-cache \
  git git-lfs \
  openssh-server openssh-keygen \
  sqlite

ARG GITEA_VERSION=release/v1.15
ARG GOPATH="/usr"
ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && apk add --no-cache --virtual .build-gitea \
  go \
  make \
  npm \
 && mkdir -p /usr/src/code.gitea.io \
 && git -C /usr/src/code.gitea.io clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git && cd /usr/src/code.gitea.io/gitea \
 && make frontend \
 && make backend \
 && mv ./gitea /usr/bin/ \
 && mkdir /etc/gitea && cp ./custom/conf/app.example.ini /etc/gitea/app.ini.sample \
 && usermod -p '*' -s /bin/bash guardian \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-gitea

COPY override /
EXPOSE 22/tcp 3000/tcp
