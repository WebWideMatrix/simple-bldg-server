#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USER
do
    echo "${date} - waiting for database to start"
    sleep 2
done


./prod/rel/bldg_server/bin/bldg_server eval BldgServer.Release.migrate

./prod/rel/bldg_server/bin/bldg_server start
