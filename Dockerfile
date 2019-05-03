FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

ARG GITEA_VERSION=v1.8.0

ENV GOPATH="/usr"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add \
   git git-lfs \
   openssh-keygen \
   openssh-server \
   sqlite \
 && apk add --virtual .build-gitea \
   build-base \
   go \
 \
 && echo "====== CONFIGURE SYSTEM ======" \
 && mkdir -p /mnt/data /etc/gitea \
 && usermod -p '*' -s /bin/bash guardian \
 \
 && echo "====== COMPILE GITEA ======" \
 && cd /usr/src \
 && go get -u code.gitea.io/gitea \
 && cd code.gitea.io/gitea \
 && git fetch && git fetch --tags \
 && cp ./custom/conf/app.ini.sample /etc/gitea/app.ini.sample \
 && git checkout "$GITEA_VERSION" \
 && TAGS="bindata sqlite sqlite_unlock_notify" make generate build \
 && mv ./gitea /usr/bin/ \
 \
 && echo "====== CLEANUP ======" \
 && cd /usr/src \
 && apk del --purge .build-gitea \
 && rm -rf /tmp/* /usr/pkg/* /usr/src/* /var/cache/apk/*

EXPOSE 22/tcp 3000/tcp
COPY override /
