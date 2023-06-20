FROM nephatrine/nxbuilder:alpine AS builder1

ARG GITEA_VERSION=v1.20.0-rc0
RUN git -C /root clone -b "$GITEA_VERSION" --single-branch --depth=1 https://github.com/go-gitea/gitea.git
RUN sed -i 's~rpm/{{$.PackageDescriptor.Owner.LowerName}}.repo~rpm.repo~g' /root/gitea/templates/package/content/rpm.tmpl
RUN sed -i 's~refName.String()~refName.ShortName()~g' /root/gitea/routers/api/actions/runner/utils.go

ARG TAGS="bindata sqlite sqlite_unlock_notify"
RUN echo "====== COMPILE GITEA ======" \
 && cd /root/gitea && make frontend

FROM nephatrine/nxbuilder:golang AS builder2

ARG GITEA_VERSION=v1.20.0-rc0
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
