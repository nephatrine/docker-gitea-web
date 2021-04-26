FROM nephatrine/alpine-s6:testing
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add \
   git git-lfs \
   openssh-server openssh-keygen \
   sqlite \
 && rm -rf /var/cache/apk/*

ARG GITEA_VERSION="master"
ARG GOPATH="/usr"
ARG TAGS="bindata sqlite sqlite_unlock_notify"

RUN echo "====== COMPILE GITEA ======" \
 && apk add --virtual .build-gitea build-base go nodejs npm \
 && cd /usr/src \
 && git clone https://github.com/go-gitea/gitea.git

 RUN cd /usr/src && cd gitea \
 && make frontend \
 && make backend \
 && mkdir /etc/gitea \
 && cp ./custom/conf/app.example.ini /etc/gitea/app.ini.sample \
 && mv ./gitea /usr/bin/ \
 && cd /usr/src && rm -rf /usr/pkg/* /usr/src/* \
 && apk del --purge .build-gitea && rm -rf /var/cache/apk/*

COPY override /
RUN echo "====== FINISHING TOUCHES ======" \
 && usermod -p '*' -s /bin/bash guardian

EXPOSE 22/tcp 3000/tcp