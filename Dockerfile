FROM pdr.nephatrine.net/nephatrine/alpine-builder:latest AS builder

ARG GITEA_VERSION=release/v1.16
RUN mkdir -p /usr/src/code.gitea.io \
 && git -C /usr/src/code.gitea.io clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git

ARG GOPATH="/usr"
ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && cd /usr/src/code.gitea.io/gitea \
 && make frontend \
 && make backend

FROM pdr.nephatrine.net/nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add --no-cache git git-lfs openssh-server openssh-keygen sqlite \
 && usermod -p '*' -s /bin/bash guardian

COPY --from=builder /usr/src/code.gitea.io/gitea/gitea /usr/bin/
COPY --from=builder /usr/src/code.gitea.io/gitea/custom/conf/app.example.ini /etc/gitea.ini.sample
COPY override /

EXPOSE 22/tcp 3000/tcp
