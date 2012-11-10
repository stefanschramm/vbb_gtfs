#!/bin/sh

DATABASE="vbb"

# Place where the GTFS textfiles are. Default: same directory as this script
DIR=$(readlink -f $(dirname $0))

dropdb ${DATABASE} || exit
createdb ${DATABASE} || exit
psql ${DATABASE} < schema.sql || exit

for TABLE in agency calendar calendar_dates routes shapes trips stops stop_times transfers ; do
	psql ${DATABASE} -c "COPY ${TABLE} FROM '${DIR}/${TABLE}.txt' WITH CSV HEADER;" || exit
done

