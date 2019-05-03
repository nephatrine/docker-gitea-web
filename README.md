[Git](https://code.nephatrine.net/nephatrine/docker-gitea-web) |
[Docker](https://hub.docker.com/r/nephatrine/gitea-web/) |
[unRAID](https://code.nephatrine.net/nephatrine/unraid-containers)

# Gitea Git Repository

This docker image contains the Gitea application - a lightweight git repository
service - using a sqlite3 database.

- [Gitea](https://gitea.io/en-us/)
- [SQLite](https://www.sqlite.org/index.html)

You can spin up a quick temporary test container like this:

~~~
docker run -rm -ti nephatrine/gitea-web:latest /bin/bash
~~~

When starting the container for the first time, sshd startup might take a
**considerable** amount of time to create the DH moduli. You can reduce this
time in a number of ways:

- Do not use diffie-hellman KexAlgorithms in ``/mnt/config/etc/ssh/sshd_config``.
- Provide your own precomputed moduli at ``/mnt/config/etc/ssh/moduli``.
- Decrease the moduli bit size using ``B_MODULI`` variable.

## Docker Tags

- **nephatrine/gitea-web:latest**: Gitea v1.8.0

## Configuration Variables

You can set these parameters using the syntax ``-e "VARNAME=VALUE"`` on your
``docker run`` command. These are typically used during the container
initialization scripts to perform initial setup.

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
syntax. These mountpoints are intended important configuration files, logs,
and application state (e.g. databases) can be retained outside the container
image and are not lost on image updates.

- ``/mnt/config``: Configuration & Logs. Do not share with multiple containers.

You can perform some basic configuration and troubleshooting of the container
using the files and directories listed below.

- ``/mnt/config/bin/``: User Scripts.
- ``/mnt/config/etc/crontabs/<user>``: User Crontabs. [*]
- ``/mnt/config/etc/gitea/app.ini``: Gitea Configuration. [*]
- ``/mnt/config/etc/logrotate.conf``: Logrotate Global Configuration.
- ``/mnt/config/etc/logrotate.d/``: Logrotate Additional Configuration.
- ``/mnt/config/etc/ssh/moduli``: SSH Diffie-Hellman Moduli. [*]
- ``/mnt/config/etc/ssh/ssh_host_<algo>_key``: SSH Server Keys. [*]
- ``/mnt/config/etc/ssh/sshd_config``: SSH Server Configuration. [*]
- ``/mnt/config/var/www/gitea/``: Gitea Custom Directory.
- ``/mnt/config/log/``: Application Logs.

**[*] Changes to some configuration files may require service restart to take
immediate effect.**

Some configuration files are required for system operation and will be
recreated with their default settings if deleted.

## Network Services

This container runs network services that are intended to be exposed outside
the container. You can map these to host ports using the ``-p HOST:CONTAINER``
or ``-p HOST:CONTAINER/PROTOCOL`` syntax.

- ``22/tcp``: SSH Server. This is optional to allow users interact with the git repos using ssh.
- ``3000/tcp``: Gitea Server. This is the Gitea web server.
