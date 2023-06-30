FROM nephatrine/nxbuilder:alpine AS builder1

ARG GITEA_VERSION=v1.20.0-rc2
RUN git -C /root clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && cd /root/gitea && make -j$(( $(getconf _NPROCESSORS_ONLN) / 2 + 1 )) frontend

FROM nephatrine/nxbuilder:golang AS builder2

ARG GITEA_VERSION=v1.20.0-rc2
COPY --from=builder1 /root/gitea/ /root/gitea/

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && cd /root/gitea && make backend

FROM nephatrine/alpine-s6:latest
LABEL maintainer="Daniel Wolf <nephatrine@gmail.com>"

RUN echo "====== INSTALL PACKAGES ======" \
 && apk add --no-cache git git-lfs openssh-server openssh-keygen sqlite \
 && usermod -p '*' -s /bin/bash guardian

COPY --from=builder2 /root/gitea/gitea /usr/bin/
COPY --from=builder2 /root/gitea/custom/conf/app.example.ini /etc/gitea.ini.sample
COPY override /

EXPOSE 22/tcp 3000/tcp
