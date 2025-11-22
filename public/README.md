<!-- DevLab README - docker-first developer guide -->

# DevLab

A small Rails app (development-focused README). This file focuses on running
the app in Docker for local development and includes quick commands to build,
start and shutdown the app using Docker / docker-compose.

## Quick start — (development)

1. Build and start the stack (web + postgres):

```bash
docker-compose up -d --build
```

2. Watch logs (tail web):

```bash
docker-compose logs -f web
```

3. Open the app in your browser:

```
http://127.0.0.1:3000/
```

4. Stop and remove containers, networks and volumes created by compose:

```bash
docker-compose down
```

5. Restart just the web service (no rebuild):

```bash
docker-compose restart web
```

## Useful one-off commands

- Run migrations inside the web container:

```bash
docker-compose run --rm web bundle exec rails db:migrate
```

- Prepare the database (create/migrate/seed):

```bash
docker-compose run --rm web bundle exec rails db:prepare
```

- Open a Rails console inside the container:

```bash
docker-compose run --rm web bin/rails console
```

- Run a one-off runner command (create a sample Article):

```bash
docker-compose run --rm web bin/rails runner "Article.create!(title: 'Hello', body: 'Welcome')"
```

## Build a local image (alternative)

If you prefer to build a standalone Docker image without docker-compose:

```bash
# build a development image
docker build -t devlab:local .

# run it (example mapping port 3000)
docker run --rm -p 3000:3000 --env-file .env -v "$PWD":/rails devlab:local
```

If your `Dockerfile` exposes a `production` stage, you can build a production
image with:

```bash
docker build --target production -t devlab:prod .
```

## Environment / secrets

Create a `.env` file (not committed) with values appropriate for local
development. Example `.env.sample` (add to repo if you want):

```env
# Database (match values used in docker-compose.yml)
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres

# Rails
RAILS_ENV=development
RAILS_MASTER_KEY=your_master_key_here
SECRET_KEY_BASE=development_secret

# Optional: when running docker run directly
DATABASE_HOST=db
DATABASE_PORT=5432
```

Notes:
- Do NOT commit `.env` or your `RAILS_MASTER_KEY` to the repo. Use
  `config/credentials.yml.enc` + `master.key` for production secrets.

## Troubleshooting

- Bundler / gem install errors during Docker build:

  - If the image fails at `bundle install` with messages about missing
    dependencies vs the lockfile, try vendoring gems locally and rebuilding:

  ```bash
  bundle config set --local path 'vendor/bundle'
  bundle package --all
  docker-compose build --no-cache
  ```

  - Alternatively you can update the lockfile locally (`bundle update <gem>`)
    and commit `Gemfile.lock`.

- Postgres not ready / connection refused on startup:

  - `bin/entrypoint.sh` included in this project waits for Postgres; ensure
    the `web` service uses that entrypoint and the `db` service has a
    healthcheck. If you get "database system is starting up" errors, stop
    and `docker-compose up` again — the entrypoint will retry until the DB
    responds.

- Stale PID error when starting Rails:

  - If you see "A server is already running (pid: ...)" remove the stale
    pid file before starting the server: `rm -f tmp/pids/server.pid`.
    The project's `entrypoint` already removes this file on startup.

## Production notes (short)

- Use multi-stage builds to produce a small production image. Ensure you
  precompile assets during the build, set `RAILS_ENV=production`, and supply
  secrets via environment variables or a secrets manager.
- Push images to your registry and deploy using your orchestration (docker
  compose, Kubernetes, etc.). Consider removing dev-only files (e.g. `vendor/cache`
  if you don't want them in the image) and using a CI pipeline to build
  and test images.

## Where to look next

- `Dockerfile` — image build and assets precompile steps
- `docker-compose.yml` — how services are wired (db, web)
- `bin/entrypoint.sh` — waits for DB, prepares DB and removes stale PIDs

---

Enjoy — run `docker-compose up -d --build` to get started.
