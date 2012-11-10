#!/bin/sh

DATABASE="vbb"

DIR=$(readlink -f $(dirname $0))

dropdb ${DATABASE}
createdb ${DATABASE}
psql ${DATABASE} < schema.sql

for TABLE in agency calendar calendar_dates routes shapes trips stops stop_times transfers ; do
	psql ${DATABASE} -c "COPY ${TABLE} FROM '/tmp/${TABLE}.txt' WITH CSV HEADER;"
done

