# Use official Elixir image
FROM hexpm/elixir:1.18.2-erlang-27.3-debian-bullseye-20250224-slim AS builder

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git nodejs npm && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set working directory
WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set environment variables
ENV MIX_ENV=prod

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy config files
COPY config/config.exs config/prod.exs config/

# Copy application code
COPY assets assets
COPY priv priv
COPY lib lib

# Install npm dependencies and compile assets
RUN cd assets && npm install && cd ..
RUN mix assets.deploy

# Compile application
RUN mix compile

# Build release
COPY rel rel
RUN mix release

# Final stage
FROM debian:bullseye-20250224-slim

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

# Set environment variables
ENV MIX_ENV=prod

# Copy release
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/f1_news ./

USER nobody

CMD ["/app/bin/f1_news", "start"]