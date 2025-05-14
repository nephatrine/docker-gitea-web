<!--
SPDX-FileCopyrightText: 2019-2025 Daniel Wolf <nephatrine@gmail.com>
SPDX-License-Identifier: ISC
-->

# Gitea Code Forge

[![NephCode](https://img.shields.io/static/v1?label=Git&message=NephCode&color=teal)](https://code.nephatrine.net/NephNET/docker-gitea-web)
[![GitHub](https://img.shields.io/static/v1?label=Git&message=GitHub&color=teal)](https://github.com/nephatrine/docker-gitea-web)
[![Registry](https://img.shields.io/static/v1?label=OCI&message=NephCode&color=blue)](https://code.nephatrine.net/NephNET/-/packages/container/gitea-web/latest)
[![DockerHub](https://img.shields.io/static/v1?label=OCI&message=DockerHub&color=blue)](https://hub.docker.com/repository/docker/nephatrine/gitea-web/general)
[![unRAID](https://img.shields.io/static/v1?label=unRAID&message=template&color=orange)](https://code.nephatrine.net/NephNET/unraid-containers)

This is an Alpine-based container hosting a Gitea forge for housing your Git
projects.

To secure this service, we suggest a separate reverse proxy server, such as
[nephatrine/nginx-ssl](https://hub.docker.com/repository/docker/nephatrine/nginx-ssl/general).

To use the built-in actions functions, you need one or more "runners", such as
[nephatrine/gitea-runner](https://hub.docker.com/repository/docker/nephatrine/gitea-runner/general).

## Supported Tags

- `gitea-web:1.23.7`: Gitea 1.23.7

## Software

- [Alpine Linux](https://alpinelinux.org/)
- [Skarnet S6](https://skarnet.org/software/s6/)
- [s6-overlay](https://github.com/just-containers/s6-overlay)
- [Gitea](https://about.gitea.com/)

## Configuration

When starting the container for the first time, sshd startup might take a
**considerable** amount of time to create the DH moduli. You can reduce this
time by providing a precomputed moduli at `/mnt/config/etc/ssh/moduli`.

There are two important configuration files you need to be aware of and
potentially customize.

- `/mnt/config/etc/gitea.ini`
- `/mnt/config/etc/ssh/sshd_config`
- `/mnt/config/www/gitea/public/robots.txt`

Modifications to these files will require a service restart to pull in the
changes made.

You can put things like favicons and other static assets into this location.

- `/mnt/config/www/gitea/public/assets/*`

### Container Variables

- `TZ`: Time Zone (i.e. `America/New_York`)
- `PUID`: Mounted File Owner User ID
- `PGID`: Mounted File Owner Group ID

## Testing

### docker-compose

```yaml
services:
  gitea-web:
    image: nephatrine/gitea-web:latest
    container_name: gitea-web
    environment:
      TZ: America/New_York
      PUID: 1000
      PGID: 1000
    ports:
      - "3000:3000/tcp"
      - "22:2020/tcp"
    volumes:
      - /mnt/containers/gitea-web:/mnt/config
```

### docker run

```bash
docker run --rm -ti code.nephatrine.net/nephnet/gitea-runner:latest /bin/bash
```
