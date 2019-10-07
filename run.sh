#!/bin/bash

# start postgres
su - postgres -c "pg_ctl start -D /var/lib/postgresql/data -l /var/lib/postgresql/log.log"

cd myapp

input="secret.env.example"
while IFS= read -r line
do
    cat >> secret.env <<-EOF
export $line
EOF
done < "$input"

source secret.env

mix deps.get
mix test
