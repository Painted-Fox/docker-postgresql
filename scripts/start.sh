#!/bin/bash
# Starts up postgresql within the container.

# Stop on error
set -e

DATA_DIR=/data
PGVERSION=9.4

if [[ -e /firstrun ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

wait_for_postgres_and_run_post_start_action() {
  # Wait for postgres to finish starting up first.
  while [[ ! -e /run/postgresql/${PGVERSION}-main.pid ]] ; do
      inotifywait -q -e create /run/postgresql/ >> /dev/null
  done

  post_start_action
}

pre_start_action

wait_for_postgres_and_run_post_start_action &

# Start PostgreSQL
echo "Starting PostgreSQL..."
setuser postgres /usr/lib/postgresql/${PGVERSION}/bin/postgres -D /etc/postgresql/${PGVERSION}/main
