DB='fanfiction_niskin_tmp'
dropdb $DB &&
createdb $DB &&
psql -d $DB -c "CREATE TABLE
stories_orig(rating CHARACTER VARYING(3),
updated date,
favorites INTEGER,
starring_chars CHARACTER VARYING(100),
chapters INTEGER,
complete BOOLEAN,
collected_info TEXT,
genre CHARACTER VARYING(50),
description TEXT,
language CHARACTER VARYING(20),
author CHARACTER VARYING(50),
url CHARACTER VARYING(200) PRIMARY KEY,
follows INTEGER,
title CHARACTER VARYING(150),
reviews INTEGER,
published DATE,
words BIGINT);" &&
psql -d $DB -c "\\copy stories_orig(rating, updated, favorites, starring_chars, chapters, complete, collected_info, genre, description, language, author, url, follows, title, reviews, published, words) FROM 'Fanfiction/stories_orig.csv' DELIMITER ',' CSV HEADER" 2> results/q4a.txt
