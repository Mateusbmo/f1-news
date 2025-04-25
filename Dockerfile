# Find eligible builder and runner images on Docker Hub. We use Ubuntu and not Debian because their OpenSSL implementations are compatible with Elixir/Erlang
FROM hexpm/elixir:1.18.2-erlang-27.3-debian-bullseye-20250224-slim AS builder

# Install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Prepare build dir
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy and install app dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy config
COPY config/config.exs config/prod.exs config/
COPY config/runtime.exs config/

# Copy source code
COPY assets assets/
COPY priv priv/
COPY lib lib/

# Build assets
RUN cd assets && npm install && cd .. && \
    mix assets.deploy

# Compile the app
RUN mix compile

# Copy release configuration
COPY rel rel/

# Build the release
RUN mix release

# Start a new build stage for a slim image
FROM debian:bullseye-20250224-slim

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /app
RUN chown nobody /app

# Copy the release from the builder
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/f1_news ./

USER nobody

# Set environment to production
ENV MIX_ENV=prod
ENV ERL_AFLAGS="-proto_dist inet6_tcp"

CMD ["/app/bin/server"]