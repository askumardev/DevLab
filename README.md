It contains commands for:

- Building Docker containers
- Running the Rails application
- Database setup
- Debugging containers
- Running tests
- Generators and useful Rails commands

---

# Prerequisites

---

| Section | Description |
|-------|-------------|
| [Installation Commands](docs/first_steps.md) | List of commands for installation |
| [rails c Commands](docs/CONSOLE_CMDS.md) | List of rails console commands |
| [generator/migrations Commands](docs/generator_migration_cmds.md) | List of rails console commands |
---


### Running RSpec Tests

Run tests:
```bash
docker-compose run --rm web bundle exec rspec
docker compose run --rm web bundle exec rspec spec
```
Run tests with documentation format:
```bash
docker-compose run --rm web bundle exec rspec --format documentation
```
- Run migrations for the TEST environment (useful for CI or debugging test DB issues):

```bash
# Create + migrate test DB (preferred)
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:prepare

# Or explicit create + migrate
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:create
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:migrate
---

### Docker Debugging Commands

List running containers:
```bash
docker ps
```
Attach to a running container:
```bash
docker attach <container_name>

Example:

docker attach devlab-web-1
```
List Docker images:
```bash
docker images
```
---
### Fix Permission Issues
```bash
Example error:

EACCES: permission denied

Example folder:

app/graphql/types

Fix permissions:

sudo chown -R $USER:$USER .

Check folder permissions:

ls -ld app/graphql/types

Example output:

drwxr-xr-x 2 root root 4096 Dec 20 14:24 app/graphql/types

Fix permissions:

sudo chown -R $USER:$USER .
```
---
### Sidekiq Setup
```bash
Add Sidekiq gem:

gem 'sidekiq'

Install gem:

bundle install

Configure ActiveJob adapter in config/application.rb:

config.active_job.queue_adapter = :sidekiq

Start Sidekiq:

bundle exec sidekiq
```
---
### Active Storage Setup

Install Active Storage:
```bash
rails active_storage:install
rails db:migrate
```
---
### Stripe Example (Rails Console)
```bash
Create customer:

customer = Stripe::Customer.create({
  name: 'abc',
  email: 'abc@example.com',
  phone: '1234567892'
})

Create token:

token = Stripe::Token.create({
  card: {
    number: '4242424242424242',
    exp_month: 7,
    exp_year: 2023,
    cvc: '314'
  }
})

Attach card to customer:

Stripe::Customer.create_source(customer.id, { source: token.id })
```
---
```bash
Hirb (Better Rails Console Output)

Enable Hirb:

require 'hirb'

Hirb.enable(width: 155, height: 500)

Show records in table format:

tp TodoList.all
Example API Endpoint
http://localhost:3000/api/v1/samples
Fun API Example

Example endpoint:

http://localhost:3000/users

Search example:

Philip J Fry

Example image location:

app/assets/images/funapi.png
Miscellaneous Commands

```
---


# Single-shell variant
docker-compose run --rm web bash -lc "RAILS_ENV=test bin/rails db:prepare"
```

Quick verify that the test schema is migrated (run inside the container):



## Build a local image (alternative)

If you prefer to build a standalone Docker image without docker-compose:


## Environment / secrets

Create a `.env` file (not committed) with values appropriate for local
development. Example `.env.sample` (add to repo if you want):

```env
# Database (match values used in docker-compose.yml)
POSTGRES_USER=xxx---xxx
POSTGRES_PASSWORD=xxx---xxx
POSTGRES_DB=xxx---xxx

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

## Where to look next

- `Dockerfile` — image build and assets precompile steps
- `docker-compose.yml` — how services are wired (db, web)
- `bin/entrypoint.sh` — waits for DB, prepares DB and removes stale PIDs

---

```
 * docker-compose build --no-cache
 * docker-compose up
 * docker-compose exec web bundle add jsbundling-rails
 * docker-compose exec web rails javascript:install:esbuild
 * docker-compose exec web yarn add @hotwired/turbo-rails @hotwired/stimulus
 * docker-compose exec web yarn add react react-dom
 * docker-compose exec web yarn build
```