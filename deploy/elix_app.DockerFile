FROM elixir:latest as build 

WORKDIR /app


ENV MIX_ENV=prod
RUN apt-get update && \
    apt-get install -y build-essential git

COPY mix.exs mix.lock ./

RUN mix local.hex --force && \
    mix local.rebar --force


RUN mix deps.get  \
    mix deps.compile

COPY . .


RUN mix compile && \
    MIX_ENV=prod mix release  


FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get install -y libssl3 openssl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/_build/prod/rel/rel_v1 ./


ENV MIX_ENV=prod
ENV PORT=4000

# Открываем порт
EXPOSE $PORT

# Запускаем приложение
CMD ["./bin/rel_v1", "start"]
