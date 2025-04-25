# Stage 1: Builder
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

# Set production environment
ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

# Install production dependencies
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy config files (excluding dev.exs)
COPY config/config.exs config/prod.exs config/runtime.exs config/

# Copy application code
COPY lib lib/
COPY priv priv/
COPY assets assets/

# Build assets (with production settings)
RUN cd assets && \
    npm install && \
    cd .. && \
    mix do deps.loadpaths --no-deps-check, assets.deploy

# Compile the application
RUN mix compile

# Copy release configuration
COPY rel rel/

# Build the release
RUN mix release

# Stage 2: Runner
FROM debian:bullseye-20250224-slim

# Install runtime dependencies
RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Setup working directory
WORKDIR /app
RUN chown nobody /app

# Copy release from builder
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/f1_news ./

# Environment variables
ENV MIX_ENV=prod
ENV PORT=8080
ENV ERL_AFLAGS="-proto_dist inet6_tcp"

# Run as nobody
USER nobody

# The command to run when the container starts
CMD ["/app/bin/f1_news", "start"]