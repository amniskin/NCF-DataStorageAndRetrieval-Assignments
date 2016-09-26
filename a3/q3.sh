DB='hubway_niskin_tmp'
psql -d $DB -c "DROP TABLE q3zip;" &&
psql -d $DB -c "DROP TABLE q3duration;" &&
psql -d $DB -c "CREATE TABLE q3zip AS
SELECT
CASE
WHEN
lower(subsc_type) LIKE 'registered' AND
zip_code IS NULL
THEN 'Registered user missing zip-code'
WHEN
lower(subsc_type) LIKE 'casual' AND
zip_code IS NOT NULL
THEN 'Casual user has zip code'
END problem,
seq_id,
hubway_id,
subsc_type,
zip_code
FROM trips
WHERE (lower(subsc_type) LIKE 'casual'
AND zip_code IS NOT NULL);" &&
psql -d $DB -c "CREATE TABLE q3duration AS
SELECT
CASE WHEN duration < 0
THEN 'The duration is negative'
WHEN duration != EXTRACT (EPOCH FROM end_date) - EXTRACT(EPOCH FROM start_date)
THEN 'The duration is not equal to the end_date - start_date'
END problem,
seq_id,
duration,
start_date,
end_date
FROM trips
WHERE duration < 0
OR duration != EXTRACT(EPOCH FROM end_date) - EXTRACT(EPOCH FROM start_date);" &&

psql -d $DB -c "SELECT * FROM q3duration WHERE problem LIKE '%not equal%' LIMIT 5;" > results/q3a.txt &&
psql -d $DB -c "SELECT * FROM q3duration WHERE problem LIKE '%is negative%' LIMIT 5;" > results/q3b.txt &&
psql -d $DB -c "SELECT * FROM q3zip WHERE problem LIKE '%has%' LIMIT 5;" > results/q3c.txt &&
psql -d $DB -c "SELECT * FROM q3zip WHERE problem LIKE '%missing%' LIMIT 5;" > results/q3d.txt
