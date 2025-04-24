# Etapa de build
FROM hexpm/elixir:1.18.2-erlang-27.3-debian-bullseye-20250224-slim AS builder

# Instalar dependências do sistema
RUN apt-get update -y && apt-get install -y build-essential git nodejs npm \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Configurar ambiente
WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force

# Copiar arquivos de configuração
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Copiar configs e assets
COPY config/config.exs config/prod.exs config/
COPY assets assets
COPY priv priv
COPY lib lib

# Instalar dependências npm e compilar assets
RUN cd assets && npm install && cd ..
RUN mix assets.deploy

# Compilar aplicação
COPY . .
RUN mix compile

# Etapa de runtime
FROM debian:bullseye-20250224-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /app
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/prod/rel/f1_news ./

USER nobody
CMD ["/app/bin/server"]