psql -d hubway_niskin_tmp -c "DROP TABLE q2c;" &&
psql -d hubway_niskin_tmp -c "CREATE TABLE q2c AS SELECT station_id FROM stations WHERE lat BETWEEN 42.3 AND 42.4 AND lng BETWEEN -71.1 AND -71;" &&
psql -d hubway_niskin_tmp -c "SELECT hubway_id FROM trips WHERE start_statn IN (SELECT station_id FROM q2c) OR end_statn IN (SELECT station_id FROM q2c) ORDER BY hubway_id LIMIT 10;" > results/q2c.txt
