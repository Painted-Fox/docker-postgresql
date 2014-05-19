# docker-postgresql

A Dockerfile that produces a container that will run [PostgreSQL][postgresql].

[postgresql]: http://www.postgresql.org/

## Image Creation

This example creates the image with the tag `paintedfox/postgresql`, but you can
change this to use your own username.

```
$ docker build -t="paintedfox/postgresql" .
```

Alternately, you can run the following if you have *make* installed...

```
$ make
```

You can also specify a custom docker username like so:

```
$ make DOCKER_USER=paintedfox
```

## Container Creation / Running

The PostgreSQL server is configured to store data in `/data` inside the
container.  You can map the container's `/data` volume to a volume on the host
so the data becomes independant of the running container. There is also an 
additional volume at `/var/log/postgresql` which exposes PostgreSQL's logs.

This example uses `/tmp/postgresql` to store the PostgreSQL data, but you can
modify this to your needs.

When the container runs, it creates a superuser with a random password.  You
can set the username and password for the superuser by setting the container's
environment variables.  This lets you discover the username and password of the
superuser from within a linked container or from the output of `docker inspect
postgresql`.

If you set DB=database_name, when the container runs it will create a new
database with the USER having full ownership of it.

``` shell
$ mkdir -p /tmp/postgresql
$ docker run -d --name="postgresql" \
             -p 127.0.0.1:5432:5432 \
             -v /tmp/postgresql:/data \
             -e USER="super" \
             -e DB="database_name" \
             -e PASS="$(pwgen -s -1 16)" \
             paintedfox/postgresql
```

Alternately, you can run the following if you have *make* installed...

``` shell
$ make run
```

You can also specify a custom port to bind to on the host, a custom data
directory, and the superuser username and password on the host like so:

``` shell
$ sudo mkdir -p /srv/docker/postgresql
$ make run PORT=127.0.0.1:5432 \
           DATA_DIR=/srv/docker/postgresql \
           USER=super \
           PASS=$(pwgen -s -1 16)
```

## Connecting to the Database

To connect to the PostgreSQL server, you will need to make sure you have
a client.  You can install the `postgresql-client` on your host machine by
running the following (Ubuntu 12.04LTS):

``` shell
$ sudo apt-get install postgresql-client
```

As part of the startup for PostgreSQL, the container will generate a random
password for the superuser.  To view the login in run `docker logs
<container_name>` like so:

``` shell
$ docker logs postgresql
POSTGRES_USER=super
POSTGRES_PASS=b2rXEpToTRoK8PBx
POSTGRES_DATA_DIR=/data
Starting PostgreSQL...
Creating the superuser: super
2014-02-07 03:30:55 UTC LOG:  database system was interrupted; last known up at 2014-02-01 07:06:21 UTC
2014-02-07 03:30:55 UTC LOG:  database system was not properly shut down; automatic recovery in progress
2014-02-07 03:30:55 UTC LOG:  record with zero length at 0/17859E8
2014-02-07 03:30:55 UTC LOG:  redo is not required
2014-02-07 03:30:55 UTC LOG:  database system is ready to accept connections
2014-02-07 03:30:55 UTC LOG:  autovacuum launcher started
```

Then you can connect to the PostgreSQL server from the host with the following
command:

``` shell
$ psql -h 127.0.0.1 -U super template1
```

Then enter the password from the `docker logs` command when prompted.

## Linking with the Database Container

You can link a container to the database container.  You may want to do this to
keep web application processes that need to connect to the database in
a separate container.

To demonstrate this, we can spin up a new container like so:

``` shell
$ docker run -t -i --link postgresql:db ubuntu bash
```

This assumes you're already running the database container with the name
*postgresql*.  The `--link postgresql:db` will give the linked container the
alias *db* inside of the new container.

From the new container you can connect to the database by running the following
commands:

``` shell
$ apt-get install -y postgresql-client
$ psql -U "$DB_ENV_USER" \
       -h "$DB_PORT_5432_TCP_ADDR" \
       -p "$DB_PORT_5432_TCP_PORT"
```

If you ran the *postgresql* container with the flags `-e USER=<user>` and `-e
PASS=<pass>`, then the linked container should have these variables available
in its environment.  Since we aliased the database container with the name
*db*, the environment variables from the database container are copied into the
linked container with the prefix `DB_ENV_`.
