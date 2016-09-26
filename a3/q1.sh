#!/bin/bash
# Let's mung! (get rid of apostrophes before zipcodes
cat Hubway/hubway_trips.csv | sed -r "s/,'([0-9]{5}),/,\1,/g" > hubway_trips_no-apos.csv &&
#delete the old copy just in case
dropdb hubway_niskin_tmp &&
# Create a fresh new perfect and vacant database
createdb hubway_niskin_tmp &&
#Create the stations table
psql -d hubway_niskin_tmp -c "CREATE TABLE stations(station_id INT PRIMARY KEY, terminal CHARACTER(6) CHECK (terminal <> ''), station CHARACTER VARYING(100), municipal CHARACTER VARYING(20), lat DOUBLE PRECISION, lng DOUBLE PRECISION, status CHARACTER VARYING(8));" &&
#Fill the stations table
psql -d hubway_niskin_tmp -c "\\copy stations(station_id, terminal, station, municipal, lat, lng, status) FROM 'Hubway/hubway_stations.csv' DELIMITER ',' CSV HEADER" &&
#Create the trips table
psql -d hubway_niskin_tmp -c "CREATE TABLE trips(seq_id SERIAL primary key, hubway_id BIGINT, status CHARACTER VARYING(10), duration INTEGER, start_date TIMESTAMP WITHOUT TIME ZONE, start_statn INTEGER REFERENCES stations(station_id), end_date TIMESTAMP WITHOUT TIME ZONE, end_statn INTEGER REFERENCES stations(station_id), bike_nr CHARACTER VARYING(20), subsc_type CHARACTER VARYING(20), zip_code CHARACTER VARYING(6), birth_date INTEGER, gender CHARACTER VARYING(10));" &&
#Fill the trips table
psql -d hubway_niskin_tmp -c "\\copy trips(seq_id, hubway_id, status, duration, start_date, start_statn, end_date, end_statn, bike_nr, subsc_type, zip_code, birth_date, gender) FROM 'hubway_trips_no-apos.csv' DELIMITER ',' CSV HEADER"
