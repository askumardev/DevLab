#!/usr/bin/env bash
set -euo pipefail

# Wait for Postgres to be ready, remove stale pids, run DB setup, then exec the given command.

: "${DATABASE_HOST:=db}"
: "${DATABASE_PORT:=5432}"
: "${DATABASE_USERNAME:=postgres}"
: "${DATABASE_PASSWORD:=postgres}"
: "${DATABASE_NAME:=dev_lab_development}"
: "${DB_WAIT_TIMEOUT:=60}"

echo "Waiting for Postgres at ${DATABASE_HOST}:${DATABASE_PORT} (timeout ${DB_WAIT_TIMEOUT}s)..."
start_ts=$(date +%s)
until pg_isready -h "${DATABASE_HOST}" -p "${DATABASE_PORT}" -U "${DATABASE_USERNAME}" >/dev/null 2>&1; do
  now=$(date +%s)
  elapsed=$(( now - start_ts ))
  if [ "$elapsed" -ge "${DB_WAIT_TIMEOUT}" ]; then
    echo "Timed out waiting for Postgres after ${DB_WAIT_TIMEOUT}s"
    exit 1
  fi
  echo "Postgres is unavailable - sleeping 1s"
  sleep 1
done

echo "Postgres is ready. Removing any stale server PID and running database prepare..."
# Remove stale server PID (prevents "A server is already running (pid: ...)" errors)
rm -f tmp/pids/server.pid || true

# If the container is started as root, ensure the bundle directory is writable
# by the app user (UID 1000). This helps `bundle install` and first-run setup.
if [ "$(id -u)" = "0" ]; then
  echo "Running as root — ensuring /usr/local/bundle is owned by UID 1000"
  mkdir -p /usr/local/bundle
  chown -R 1000:1000 /usr/local/bundle || true
fi

# Allow skipping the automatic DB prepare step when NO_ENTRYPOINT=1 is set.
# This is useful for one-off commands like `bundle install` where the entrypoint
# would otherwise attempt to run Rails commands before gems are available.
if [ "${NO_ENTRYPOINT:-0}" = "1" ]; then
  echo "NO_ENTRYPOINT=1 — skipping db:prepare"
  echo "Starting process: $@"
  exec "$@"
fi

# Use db:prepare which creates database and runs migrations in one command
bundle exec rails db:prepare

echo "Starting process: $@"
exec "$@"

