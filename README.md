[Git](https://code.nephatrine.net/nephatrine/docker-gitea-web) |
[Docker](https://hub.docker.com/r/nephatrine/gitea-web/) |
[unRAID](https://code.nephatrine.net/nephatrine/unraid-containers)

[![Build Status](https://ci.nephatrine.net/api/badges/nephatrine/docker-gitea-web/status.svg?ref=refs/heads/master)](https://ci.nephatrine.net/nephatrine/docker-gitea-web)

# Gitea Git Repository

This docker image contains a Gitea server to self-host your own git
repositories.

**YOU WILL NEED TO USE A SEPARATE REVERSE PROXY SERVER TO SECURE THIS SERVICE.
FOR INSTANCE, AN [NGINX](https://nginx.com/) REVERSE PROXY CONTAINER.**

- [Gitea](https://gitea.io/en-us/)
- [OpenSSH](https://openssh.com/)
- [SQLite](https://www.sqlite.org/)

You can spin up a quick temporary test container like this:

~~~
docker run --rm -p 3000:3000 -v /var/run/docker.sock:/run/docker.sock -it nephatrine/gitea-web:latest /bin/bash
~~~

When starting the container for the first time, sshd startup might take a
**considerable** amount of time to create the DH moduli. You can reduce this
time in a number of ways:

- Do not use diffie-hellman KexAlgorithms in ``/mnt/config/etc/ssh/sshd_config``.
- Provide your own precomputed moduli at ``/mnt/config/etc/ssh/moduli``.
- Decrease the moduli bit size using ``B_MODULI`` variable.

## Docker Tags

- **nephatrine/gitea-web:testing**: Gitea Development (*master*)
- **nephatrine/gitea-web:latest**: Gitea v1.10 (*release/v1.10*)
- **nephatrine/gitea-web:1.9**: Gitea v1.9 (*release/v1.9*)
- **nephatrine/gitea-web:1.8**: Gitea v1.8 (*release/v1.8*)
- **nephatrine/gitea-web:1.7**: Gitea v1.7 (*release/v1.7*)

## Configuration Variables

You can set these parameters using the syntax ``-e "VARNAME=VALUE"`` on your
``docker run`` command. Some of these may only be used during initial
configuration and further changes may need to be made in the generated
configuration files.

- ``B_MODULI``: Default SSH Moduli Size (*4096*)
- ``B_DSA``: Default DSA Key Size (*1024*)
- ``B_RSA``: Default RSA Key Size (*4096*)
- ``B_ECDSA``: Default ECDSA Key Size (*384*)
- ``B_ED25519``: Default ed25519 Key Size (*256*)
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
