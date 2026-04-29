
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
