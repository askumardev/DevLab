It contains commands for:

- Building Docker containers
- Running the Rails application
- Database setup
- Debugging containers
- Running tests
- Generators and useful Rails commands

---

# Prerequisites

Make sure the following are installed:

- Docker
- Docker Compose
- Git

Verify installation:

```bash
docker --version
docker-compose --version
```

---
### Docker Commands
First Time Setup (New Environment)

If you are running the project for the first time:
```bash
docker-compose build
docker-compose up -d
docker-compose run --rm web bundle install
docker-compose run --rm web rails db:drop db:create db:migrate db:seed
```

Already Configured Application

If the application is already built and configured:

Start containers:
```bash
docker-compose up
```
Run in background:
```bash
docker-compose up -d
```
Stop containers:
```bash
docker-compose down
```
Rebuild containers:
```bash
docker-compose build
```
Rebuild only the web service:
```bash
docker-compose build web
```

---
Running the Rails Server

Start the application:
```bash
docker-compose up
```
Visit the application:
```bash
http://localhost:3000
```

---


Database Commands

Run migrations:

docker-compose run --rm web rails db:migrate

Seed database:

docker-compose run --rm web rails db:seed

Reset database:

docker-compose run --rm web rails db:reset

Drop and recreate database:

docker-compose run --rm web rails db:drop db:create db:migrate db:seed
Rails Generators

Generate model:

docker-compose run --rm web rails generate model Location state:string district:string pincode:string

Other generators:

rails generate model Student
rails generate controller Student
rails g migration add_passing_year_in_student_degrees
rails g serializer TodoList
rails g mailer bookings booking_confirmation

Run migrations:

rails db:migrate
Useful Rails Commands

Open Rails console:

docker-compose exec web rails console

Show routes:

docker-compose run --rm web rails routes

Filter routes:

docker-compose run --rm web rails routes | grep chat
Running RSpec Tests

Add RSpec gem:

gem "rspec"

Install gem:

bundle install

Run tests:

docker-compose run --rm web bundle exec rspec

Run tests with documentation format:

docker-compose run --rm web bundle exec rspec --format documentation
Docker Debugging Commands

List running containers:

docker ps

Attach to a running container:

docker attach <container_name>

Example:

docker attach devlab-web-1

List Docker images:

docker images
Fix Permission Issues

Example error:

EACCES: permission denied

Example folder:

app/graphql/types

Fix permissions:

sudo chown -R $USER:$USER .
Sidekiq Setup

Add Sidekiq gem:

gem 'sidekiq'

Install gem:

bundle install

Configure ActiveJob adapter in config/application.rb:

config.active_job.queue_adapter = :sidekiq

Start Sidekiq:

bundle exec sidekiq

Start Rails server:

rails s

Visit:

http://localhost:3000
Active Storage Setup

Install Active Storage:

rails active_storage:install
rails db:migrate
Stripe Example (Rails Console)

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

Remove temporary files:

sudo rm -rf tmp

Build Docker image manually:

sudo docker build -t myapp .

Run Docker Compose manually:

sudo docker-compose up
Folder Permission Example

Check folder permissions:

ls -ld app/graphql/types

Example output:

drwxr-xr-x 2 root root 4096 Dec 20 14:24 app/graphql/types

Fix permissions:

sudo chown -R $USER:$USER .




<!-- 
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

- Run migrations for the TEST environment (useful for CI or debugging test DB issues):

```bash
# Create + migrate test DB (preferred)
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:prepare

# Or explicit create + migrate
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:create
docker-compose run --rm -e RAILS_ENV=test web bin/rails db:migrate

# Single-shell variant
docker-compose run --rm web bash -lc "RAILS_ENV=test bin/rails db:prepare"
```

Quick verify that the test schema is migrated (run inside the container):

```bash
docker-compose exec web rails runner "puts ActiveRecord::Base.connection.migration_context.needs_migration?"
```

Run the test suite (RSpec uses `test`/`development` depending on config):

```bash
docker-compose run --rm web bundle exec rspec
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

If you'd like, I can:
- Add a `README` section that documents the `docker-compose` service names and ports in more detail.
- Add a `.env.sample` file to the repo and a `.dockerignore` to speed builds.
- Add simple integration tests or a `Makefile` with common commands.

Enjoy — run `docker-compose up -d --build` to get started.

-->