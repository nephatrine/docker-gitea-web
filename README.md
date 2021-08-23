[Git](https://code.nephatrine.net/nephatrine/docker-gitea-web/src/branch/master) |
[Docker](https://hub.docker.com/r/nephatrine/gitea-web/) |
[unRAID](https://code.nephatrine.net/nephatrine/unraid-containers)

[![Build Status](https://ci.nephatrine.net/api/badges/nephatrine/docker-gitea-web/status.svg?ref=refs/heads/master)](https://ci.nephatrine.net/nephatrine/docker-gitea-web)

# Gitea Git Repository

This docker image contains a Gitea server to self-host your own git
repositories.

**YOU WILL NEED TO USE A SEPARATE REVERSE PROXY SERVER TO SECURE THIS SERVICE.
FOR INSTANCE, AN [NGINX](https://nginx.com/) REVERSE PROXY CONTAINER.**

- [Alpine Linux](https://alpinelinux.org/)
- [Skarnet Software](https://skarnet.org/software/)
- [S6 Overlay](https://github.com/just-containers/s6-overlay)
- [Gitea](https://gitea.io/en-us/)
- [OpenSSH](https://openssh.com/)
- [SQLite](https://www.sqlite.org/)

You can spin up a quick temporary test container like this:

~~~
docker run --rm -p 3000:3000 -it nephatrine/gitea-web:latest /bin/bash
~~~

When starting the container for the first time, sshd startup might take a
**considerable** amount of time to create the DH moduli. You can reduce this
time in two ways:

- Provide your own precomputed moduli at ``/mnt/config/etc/ssh/moduli``.
- Decrease the moduli bit size using ``B_MODULI`` variable.

## Docker Tags

- **nephatrine/gitea-web:testing**: Gitea 1.15 / Alpine Edge
- **nephatrine/gitea-web:latest**: Gitea 1.15 / Alpine Latest

## Configuration Variables

You can set these parameters using the syntax ``-e "VARNAME=VALUE"`` on your
``docker run`` command. Some of these may only be used during initial
configuration and further changes may need to be made in the generated
configuration files.

- ``B_MODULI``: Default SSH Moduli Size (*4096*)
- ``B_DSA``: Default DSA Key Size (*1024*)
- ``B_RSA``: Default RSA Key Size (*4096*)
- ``B_ECDSA``: Default ECDSA Key Size (*384*)
- ``PUID``: Mount Owner UID (*1000*)
- ``PGID``: Mount Owner GID (*100*)
- ``TZ``: System Timezone (*America/New_York*)

## Persistent Mounts

You can provide a persistent mountpoint using the ``-v /host/path:/container/path``
syntax. These mountpoints are intended to house important configuration files,
logs, and application state (e.g. databases) so they are not lost on image
update.

- ``/mnt/config``: Persistent Data.

Do not share ``/mnt/config`` volumes between multiple containers as they may
interfere with the operation of one another.

You can perform some basic configuration of the container using the files and
directories listed below.

- ``/mnt/config/etc/crontabs/<user>``: User Crontabs. [*]
- ``/mnt/config/etc/gitea/app.ini``: Gitea Configuration. [*]
- ``/mnt/config/etc/logrotate.conf``: Logrotate Global Configuration.
- ``/mnt/config/etc/logrotate.d/``: Logrotate Additional Configuration.
- ``/mnt/config/etc/ssh/moduli``: SSH Diffie-Hellman Moduli. [*]
- ``/mnt/config/etc/ssh/ssh_host_<algo>_key``: SSH Server Keys. [*]
- ``/mnt/config/etc/ssh/sshd_config``: SSH Server Configuration. [*]
- ``/mnt/config/www/gitea/``: Gitea Customization Directory.

**[*] Changes to some configuration files may require service restart to take
immediate effect.**

## Network Services

This container runs network services that are intended to be exposed outside
the container. You can map these to host ports using the ``-p HOST:CONTAINER``
or ``-p HOST:CONTAINER/PROTOCOL`` syntax.

- ``22/tcp``: SSH Server. This is the optional SSH server.
- ``3000/tcp``: Gitea Server. This is the web server.
