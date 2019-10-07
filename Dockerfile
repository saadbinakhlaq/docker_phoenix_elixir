  
# Elixir + Phoenix

FROM elixir:1.9.1-alpine

# Install debian packages
RUN apk update
RUN apk --no-cache --update add \
  make \
  g++ \
  wget \
  curl \
  bash \
  inotify-tools \ 
  postgresql \
  postgresql-client

ENV PHOENIX_VERSION=1.4.9
# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new $PHOENIX_VERSION

RUN (addgroup -S postgres && adduser -S postgres -G postgres || true)
RUN mkdir -p /var/lib/postgresql/data
RUN mkdir -p /run/postgresql/
RUN chown -R postgres:postgres /run/postgresql/
RUN chmod -R 777 /var/lib/postgresql/data
RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN su - postgres -c "initdb /var/lib/postgresql/data"
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf
RUN su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log"

CMD ["bash"]