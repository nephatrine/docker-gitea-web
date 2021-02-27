FROM nephatrine/alpine-s6:3.13
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add \
   git git-lfs \
   openssh-server openssh-keygen \
   sqlite \
 && rm -rf /var/cache/apk/*

ARG GITEA_VERSION=release/v1.13
ARG GOPATH="/usr"
ARG TAGS="bindata sqlite sqlite_unlock_notify"

RUN echo "====== COMPILE GITEA ======" \
 && apk add --virtual .build-gitea build-base go nodejs npm \
 && cd /usr/src \
 && go get -d code.gitea.io/gitea && cd code.gitea.io/gitea \
 && git fetch && git fetch --tags \
 && git checkout "$GITEA_VERSION" \
 && make frontend \
 && make backend \
 && mv ./gitea /usr/bin/ \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-gitea && rm -rf /var/cache/apk/*

COPY override /
RUN echo "====== FINISHING TOUCHES ======" \
 && usermod -p '*' -s /bin/bash guardian \
 && cp /etc/gitea/${GITEA_VERSION}/app.ini* /etc/gitea/ \
 && rm -rf /etc/gitea/release

EXPOSE 22/tcp 3000/tcp