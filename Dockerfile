FROM hexpm/elixir:1.18.2-erlang-27.3-debian-bullseye-20250224-slim AS builder

RUN apt-get update -y && \
    apt-get install -y build-essential git curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config/config.exs config/prod.exs config/
COPY config/runtime.exs config/
COPY assets assets/
COPY priv priv/
COPY lib lib/

RUN cd assets && npm install && cd .. && \
    mix assets.deploy

RUN mix compile

COPY rel rel/
RUN mix release

FROM debian:bullseye-20250224-slim

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/prod/rel/f1_news ./

USER nobody
CMD ["/app/bin/server"]