DB='fanfiction_niskin_tmp'
psql -d $DB -c "ALTER TABLE stories_orig DROP CONSTRAINT stories_orig_pkey;" &&
psql -d $DB -c "ALTER TABLE stories_orig ADD col_id SERIAL PRIMARY KEY;" &&
psql -d $DB -c "ALTER TABLE stories_orig ALTER COLUMN url TYPE TEXT;" &&
psql -d $DB -c "ALTER TABLE stories_orig ALTER COLUMN author TYPE TEXT;"
