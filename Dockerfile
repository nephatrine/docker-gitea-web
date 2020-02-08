FROM nephatrine/alpine-s6:3.11
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add \
   git git-lfs \
   openssh-server openssh-keygen \
   sqlite \
 && rm -rf /var/cache/apk/*

ARG GITEA_VERSION=release/v1.11
ARG GOPATH="/usr"

RUN echo "====== COMPILE GITEA ======" \
 && mkdir /etc/gitea \
 && apk add --virtual .build-gitea build-base go \
 && cd /usr/src \
 && go get -u code.gitea.io/gitea && cd code.gitea.io/gitea \
 && git fetch && git fetch --tags \
 && git checkout "$GITEA_VERSION" \
 && TAGS="bindata sqlite sqlite_unlock_notify" make generate build \
 && cp ./custom/conf/app.ini.sample /etc/gitea/app.ini.sample \
 && mv ./gitea /usr/bin/ \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-gitea && rm -rf /var/cache/apk/*

COPY override /
RUN echo "====== FINISHING TOUCHES ======" \
 && usermod -p '*' -s /bin/bash guardian \
 && cp /etc/gitea/${GITEA_VERSION}/app.ini /etc/gitea/app.ini

EXPOSE 22/tcp 3000/tcp