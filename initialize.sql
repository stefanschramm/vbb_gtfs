-- create required tables

CREATE TABLE agency(
	agency_id INT PRIMARY KEY,
	agency_name VARCHAR(255),
	agency_url VARCHAR(255),
	agency_timezone VARCHAR(128)
);

CREATE TABLE calendar_dates(
	service_id INT,
	`date` DATE,
	exception_type TINYINT(1)
);

-- TODO: BIT instead of TINYINT?
CREATE TABLE calendar(
	service_id INT,
	monday TINYINT(1),
	tuesday TINYINT(1),
	wednesday TINYINT(1),
	thursday TINYINT(1),
	friday TINYINT(1),
	saturday TINYINT(1),
	sunday TINYINT(1),
	start_date DATE,
	end_date DATE
);

CREATE TABLE routes(
	route_id INT PRIMARY KEY,
	agency_id INT REFERENCES agency(agency_id),
	route_short_name VARCHAR(255),
	route_long_name VARCHAR(255),
	route_type TINYINT(1)
);

CREATE TABLE shapes(
	shape_id INT,
	shape_pt_lat FLOAT,
	shape_pt_lon FLOAT,
	shape_pt_sequence INT
);

CREATE TABLE stops(
	stop_id BIGINT PRIMARY KEY,
	stop_code VARCHAR(64),
	stop_name VARCHAR(255),
	stop_desc TINYINT(1), -- unused
	stop_lat FLOAT,
	stop_lon FLOAT,
	location_type TINYINT(1),
	parent_station INT
);

CREATE TABLE trips(
	route_id INT REFERENCES routes(route_id),
	service_id INT,
	trip_id INT PRIMARY KEY,
	trip_headsign VARCHAR(255),
	trip_short_name VARCHAR(255),
	direction_id TINYINT(1),
	block_id TINYINT(1),
	shape_id INT
);

CREATE TABLE stop_times(
	trip_id INT REFERENCES trips(trip_id),
	arrival_time TIME,
	departure_time TIME,
	stop_id BIGINT REFERENCES stops(stop_id),
	stop_sequence INT
);

CREATE TABLE transfers(
	from_stop_id BIGINT REFERENCES stops(stop_id),
	to_stop_id BIGINT REFERENCES stops(stop_id),
	transfer_type TINYINT(1),
	min_transfer_time INT
);

-- import gtfs data

LOAD DATA INFILE '/tmp/agency.txt' INTO TABLE agency CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/calendar.txt' INTO TABLE calendar CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/calendar_dates.txt' INTO TABLE calendar_dates CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/routes.txt' INTO TABLE routes CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/shapes.txt' INTO TABLE shapes CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/stop_times.txt' INTO TABLE stop_times CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/stops.txt' INTO TABLE stops CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/transfers.txt' INTO TABLE transfers CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '/tmp/trips.txt' INTO TABLE trips CHARACTER SET 'utf8' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

