#!/bin/sh

USERNAME='root'
PASSWORD=''
DATABASE="vbb"

DIR=$(readlink -f $(dirname $0))

mysql -v --user ${USERNAME} -e "DROP DATABASE ${DATABASE};"
mysql -v --user ${USERNAME} -e "CREATE DATABASE ${DATABASE};"
mysql -v --user ${USERNAME} ${DATABASE} < schema.sql

for TABLE in agency calendar calendar_dates routes shapes trips stops stop_times transfers ; do
	mysql -v --user ${USERNAME} ${DATABASE} -e "LOAD DATA INFILE '${DIR}/${TABLE}.txt' INTO TABLE ${TABLE} CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;"
done

