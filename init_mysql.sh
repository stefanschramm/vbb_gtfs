#!/bin/sh

USERNAME='root'
PASSWORD='test'
DATABASE="vbb"

# On a fresh installation of MySQL the password can be set using:
# mysqladmin -u root password test

# Place where the GTFS textfiles are. Default: same directory as this script
DIR=$(readlink -f $(dirname $0))

mysql -v --user ${USERNAME} -p"${PASSWORD}" -e "DROP DATABASE ${DATABASE};"
mysql -v --user ${USERNAME} -p"${PASSWORD}" -e "CREATE DATABASE ${DATABASE};" || exit
mysql -v --user ${USERNAME} -p"${PASSWORD}" ${DATABASE} < schema.sql || exit

for TABLE in agency calendar calendar_dates routes shapes trips stops stop_times transfers ; do
	mysql -v --user ${USERNAME} -p"${PASSWORD}" ${DATABASE} -e "LOAD DATA INFILE '${DIR}/${TABLE}.txt' INTO TABLE ${TABLE} CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;" || exit
done

