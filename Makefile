COMPOSE ?= docker-compose
SERVICE ?= web
RSPEC_CMD ?= bundle exec rspec

.PHONY: help rspec

help:
	@echo "Available targets:"
	@echo "  make rspec        # run RSpec inside the $(SERVICE) service (pass ARGS)"

# Run RSpec inside the docker-compose service. Use ARGS to pass rspec args,
# e.g. `make rspec ARGS="spec/requests/articles_spec.rb:10"`
rspec:
	@echo "Running: $(COMPOSE) run --rm -e NO_ENTRYPOINT=1 $(SERVICE) bash -lc 'rm -rf tmp/cache && $(RSPEC_CMD) $(ARGS)'"
	$(COMPOSE) run --rm -e NO_ENTRYPOINT=1 $(SERVICE) bash -lc "rm -rf tmp/cache && $(RSPEC_CMD) $(ARGS)"
