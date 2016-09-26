psql -d hubway_niskin_tmp -c "SELECT station FROM stations WHERE lower(status) LIKE 'removed' ORDER BY station LIMIT 10;" > results/q2a.txt
