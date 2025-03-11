FROM elixir:latest
WORKDIR /app


# ENV MIX_ENV=prod
RUN apt-get update && \
    apt-get install -y build-essential git

COPY . .

RUN mix local.hex --force && \
    mix local.rebar --force


RUN mix deps.get  \
    mix deps.compile


RUN mix compile && \
    MIX_ENV=prod mix release  


# FROM debian:bookworm-slim
# RUN apt-get update && \
#     apt-get install -y libssl3 openssl && \
#     rm -rf /var/lib/apt/lists/*

# WORKDIR /app
# COPY _build/prod/ ./

CMD ["_build/prod/rel/rel_v1/bin/rel_v1", "start"]
