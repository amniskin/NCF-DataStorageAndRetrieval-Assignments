DB='fanfiction_niskin_tmp'
psql -d $DB -c "EXPLAIN SELECT * FROM stories_orig s
  WHERE col_id = (SELECT MIN(col_id) FROM stories_orig b WHERE s.url = b.url);" > results/q4c1.txt &&
psql -d $DB -c "CREATE INDEX story_url_index ON stories_orig (url);" &&
psql -d $DB -c "EXPLAIN SELECT * FROM stories_orig s
  WHERE col_id = (SELECT MIN(col_id)
                    FROM stories_orig b WHERE s.url = b.url);" > results/q4c2.txt &&
psql -d $DB -c "SELECT * FROM stories_orig s
  WHERE col_id = (SELECT MIN(col_id)
                    FROM stories_orig b WHERE s.url = b.url);" > results/q4c3.txt
