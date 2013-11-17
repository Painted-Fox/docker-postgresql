#!/bin/bash
# Starts up postgresql within the container.

DATADIR="/data"
POSTGRES="/usr/lib/postgresql/9.3/bin/postgres"

# Ensure postgres owns the DATADIR
chown -R postgres $DATADIR
# Ensure we have the right permissions set on the DATADIR
chmod -R 700 $DATADIR

# test if DATADIR has content
if [ ! "$(ls -A $DATADIR)" ]; then
  echo "Initializing Postgres at $DATADIR"
  chown -R postgres $DATADIR

  # Copy the data that we generated within the container to the empty DATADIR.
  su postgres -c "cp -R /var/lib/postgresql/9.3/main/* $DATADIR"
fi

su postgres -c '/usr/lib/postgresql/9.3/bin/postgres -D /etc/postgresql/9.3/main'
