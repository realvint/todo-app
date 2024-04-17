FROM ruby:2.7.8-slim-bullseye

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR /rails-api

COPY Gemfile Gemfile.lock ./

RUN mkdir -p log && touch log/development.log

RUN gem install bundler -v 2.4.22

RUN bundle install

RUN gem install foreman

# Start the main process.
CMD ["foreman", "start", "-f", "Procfile"]
