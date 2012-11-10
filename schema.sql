
-- Schema should be compatible with PostgreSQL 9 and MySQL 5

CREATE TABLE agency (
	agency_id INT PRIMARY KEY,
	agency_name VARCHAR(255) NOT NULL,
	agency_url VARCHAR(255) NOT NULL,
	agency_timezone VARCHAR(128) NOT NULL
);

CREATE TABLE calendar_dates (
	service_id INT NOT NULL,
	date DATE NOT NULL,
	exception_type SMALLINT NOT NULL,
	PRIMARY KEY (service_id, date)
);

CREATE TABLE calendar (
	service_id INT PRIMARY KEY,
	monday SMALLINT NOT NULL,
	tuesday SMALLINT NOT NULL,
	wednesday SMALLINT NOT NULL,
	thursday SMALLINT NOT NULL,
	friday SMALLINT NOT NULL,
	saturday SMALLINT NOT NULL,
	sunday SMALLINT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);

CREATE TABLE routes (
	route_id INT PRIMARY KEY,
	agency_id INT REFERENCES agency (agency_id),
	route_short_name VARCHAR(255),
	route_long_name VARCHAR(255) NOT NULL,
	route_type SMALLINT NOT NULL
);

CREATE TABLE shapes (
	shape_id INT NOT NULL,
	shape_pt_lat FLOAT NOT NULL,
	shape_pt_lon FLOAT NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
);

CREATE TABLE stops (
	stop_id BIGINT PRIMARY KEY,
	stop_code VARCHAR(64) NOT NULL,
	stop_name VARCHAR(255) NOT NULL,
	stop_desc VARCHAR(1), -- unused
	stop_lat FLOAT NOT NULL,
	stop_lon FLOAT NOT NULL,
	location_type SMALLINT NOT NULL,
	parent_station BIGINT REFERENCES stops (stop_id)
);

CREATE TABLE trips (
	route_id INT REFERENCES routes (route_id),
	service_id INT NOT NULL,
	trip_id INT PRIMARY KEY,
	trip_headsign VARCHAR(255) NOT NULL,
	trip_short_name VARCHAR(255) NOT NULL,
	direction_id SMALLINT NOT NULL,
	block_id SMALLINT,
	shape_id INT
);

CREATE TABLE stop_times (
	trip_id INT REFERENCES trips (trip_id),
	-- (using VARCHAR(8) instead of TIME here because it would clash in PostgreSQL when value is >= 32:00:00)
	arrival_time VARCHAR(8) NOT NULL,
	departure_time VARCHAR(8) NOT NULL,
	stop_id BIGINT REFERENCES stops (stop_id),
	stop_sequence INT NOT NULL,
	PRIMARY KEY (trip_id, stop_sequence)
);

CREATE TABLE transfers (
	from_stop_id BIGINT REFERENCES stops (stop_id),
	to_stop_id BIGINT REFERENCES stops (stop_id),
	transfer_type SMALLINT NOT NULL,
	min_transfer_time INT,
	PRIMARY KEY (from_stop_id, to_stop_id)
);

