CREATE TABLE agency(
	agency_id INT PRIMARY KEY,
	agency_name VARCHAR(255),
	agency_url VARCHAR(255),
	agency_timezone VARCHAR(128)
);

CREATE TABLE calendar_dates(
	service_id INT,
	date DATE,
	exception_type SMALLINT,
	PRIMARY KEY (service_id, date)
);

CREATE TABLE calendar(
	service_id INT PRIMARY KEY,
	monday BIT,
	tuesday BIT,
	wednesday BIT,
	thursday BIT,
	friday BIT,
	saturday BIT,
	sunday BIT,
	start_date DATE,
	end_date DATE
);

CREATE TABLE routes(
	route_id INT PRIMARY KEY,
	agency_id INT REFERENCES agency(agency_id),
	route_short_name VARCHAR(255),
	route_long_name VARCHAR(255),
	route_type SMALLINT
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
	stop_desc SMALLINT, -- unused
	stop_lat FLOAT,
	stop_lon FLOAT,
	location_type SMALLINT,
	parent_station BIGINT REFERENCES stops(stop_id)
);

CREATE TABLE trips(
	route_id INT REFERENCES routes(route_id),
	service_id INT,
	trip_id INT PRIMARY KEY,
	trip_headsign VARCHAR(255),
	trip_short_name VARCHAR(255),
	direction_id SMALLINT,
	block_id SMALLINT,
	shape_id INT
);

CREATE TABLE stop_times(
	trip_id INT REFERENCES trips(trip_id),
	-- arrival_time TIME,
	-- departure_time TIME,
	-- (not using DATE here because it will clash in postgres when >= 32:00:00)
	arrival_time VARCHAR(8),
	departure_time VARCHAR(8),
	stop_id BIGINT REFERENCES stops(stop_id),
	stop_sequence INT
);

CREATE TABLE transfers(
	from_stop_id BIGINT REFERENCES stops(stop_id),
	to_stop_id BIGINT REFERENCES stops(stop_id),
	transfer_type SMALLINT,
	min_transfer_time INT
);

