psql -d hubway_niskin_tmp -c "SELECT station FROM stations WHERE lat BETWEEN 42.3 AND 42.4 AND lng BETWEEN -71.1 AND -71 ORDER BY station_id LIMIT 10;" > results/q2b.txt
