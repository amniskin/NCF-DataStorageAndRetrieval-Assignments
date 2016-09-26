DROP DATABASE IF EXISTS hubway_niskin
CREATE DATABASE hubway_niskin
CREATE TABLE stations(station_id INT PRIMARY KEY, terminal CHARACTER(6) CHECK (terminal <> ''), station CHARACTER VARYING(100), municipal CHARACTER VARYING(20), lat DOUBLE PRECISION, lng DOUBLE PRECISION, status CHARACTER VARYING(8));
\copy stations(station_id, terminal, station, municipal, lat, lng, status) FROM 'hubway_stations.csv' DELIMITER ',' CSV HEADER
CREATE TABLE trips (seq_id SERIAL primary key, hubway_id BIGINT, status CHARACTER VARYING(10), duration INTEGER, start_date TIMESTAMP WITHOUT TIME ZONE, start_statn INTEGER REFERENCES stations(station_id), end_date TIMESTAMP WITHOUT TIME ZONE, end_statn INTEGER REFERENCES stations(station_id), bike_nr CHARACTER VARYING(20), subsc_type CHARACTER VARYING(20), zip_code CHARACTER VARYING(6), birth_date INTEGER, gender CHARACTER VARYING(10));
\copy trips(seq_id, hubway_id, status, duration, start_date, start_statn, end_date, end_statn, bike_nr, subsc_type, zip_code, birth_date, gender) FROM 'hubway_trips_no-apos.csv' DELIMITER ',' CSV HEADER
