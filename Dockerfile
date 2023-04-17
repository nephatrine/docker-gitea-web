FROM nephatrine/nxbuilder:golang AS builder

ARG GITEA_VERSION=release/v1.19
RUN mkdir -p /usr/src \
 && git -C /usr/src clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && cd /usr/src/gitea \
 && make frontend \
 && make backend

FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add --no-cache git git-lfs openssh-server openssh-keygen sqlite \
 && usermod -p '*' -s /bin/bash guardian

COPY --from=builder /usr/src/gitea/gitea /usr/bin/
COPY --from=builder /usr/src/gitea/custom/conf/app.example.ini /etc/gitea.ini.sample
COPY override /

EXPOSE 22/tcp 3000/tcp
