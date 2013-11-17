# docker-redis

A Dockerfile that produces a container that will run [Postgresql][postgresql].

[postgresql]: http://www.postgresql.org/

## Image Creation

```
$ sudo docker build -t="postgresql" .
```

## Container Creation / Running

The Postgresql server is configured to store data in `/data` inside the container.  You can map the container's `/data` volume to a volume on the host so the data becomes independant of the running container.

This example uses `/tmp/postgresql` to store the Postgresql data, but you can modify this to your needs.

```
$ mkdir -p /tmp/postgresql
$ sudo docker run -p 5432 -v /tmp/postgresql:/data postgresql
```
