FROM elixir:latest as build 

WORKDIR /app

# Устанавливаем переменные окружения
ENV MIX_ENV=prod
RUN apt-get update && \
    apt-get install -y build-essential git

COPY mix.exs mix.lock ./

# Устанавливаем Hex и Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Устанавливаем зависимости
RUN mix deps.get  \
    mix deps.compile

COPY . .

# Компилируем проект
RUN mix compile && \
    MIX_ENV=prod mix release  


FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get install -y libssl3 openssl && \
    rm -rf /var/lib/apt/lists/*
# Копируем релиз из предыдущего этапа
WORKDIR /app
COPY --from=build /app/_build/prod/rel/rel_v1 ./

# Устанавливаем переменные окружения
ENV MIX_ENV=prod
ENV PORT=4000

# Открываем порт
EXPOSE $PORT

# Запускаем приложение
CMD ["./bin/rel_v1", "start"]
