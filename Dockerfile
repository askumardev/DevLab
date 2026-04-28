FROM ruby:3.3.3

ENV LANG=C.UTF-8 \
    BUNDLER_VERSION=2.5.14

WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y curl gnupg postgresql-client

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install bundler
RUN gem install bundler -v "$BUNDLER_VERSION"

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy project
COPY . .

# Create non-root user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID appuser && \
    useradd -m -u $UID -g $GID appuser

RUN chown -R appuser:appuser /usr/local/bundle

USER appuser