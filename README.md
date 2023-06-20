[Git](https://code.nephatrine.net/NephNET/docker-gitea-web/src/branch/master) |
[Docker](https://hub.docker.com/r/nephatrine/gitea-web/) |
[unRAID](https://code.nephatrine.net/NephNET/unraid-containers)

# Gitea Git Repository

This docker image contains a Gitea server to self-host your own git
repositories.

The `latest` tag points to version `1.20.0-rc0` and this is the only image
actively being updated. There are tags for older versions, but these may no
longer be using the latest Alpine version and packages.

To secure this service, we suggest a separate reverse proxy server, such as an
[NGINX](https://nginx.com/) container. Alternatively, Gitea does include
built-in options for using your own SSL certificates or using an ACME service
such as LetsEncrypt.

## Docker-Compose

This is an example docker-compose file:

```yaml
services:
  gitea:
    image: nephatrine/gitea-web:latest
    container_name: gitea
    environment:
      TZ: America/New_York
      PUID: 1000
      PGID: 1000
      B_MODULI: 4096
      B_DSA: 1024
      B_RSA: 4096
      B_ECDSA: 384
    ports:
      - "3000:3000/tcp"
      - "22:22/tcp"
    volumes:
      - /mnt/containers/gitea:/mnt/config
```

When starting the container for the first time, sshd startup might take a
**considerable** amount of time to create the DH moduli. You can reduce this
time by providing a precomputed moduli at `/mnt/config/etc/ssh/moduli`.

## Server Configuration

There are two important configuration files you need to be aware of and
potentially customize.

- `/mnt/config/etc/gitea.ini`
- `/mnt/config/etc/ssh/sshd_config`

Modifications to these files will require a service restart to pull in the
changes made.
