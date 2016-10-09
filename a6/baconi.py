import csv
import psycopg2
import datetime

#conn = psycopg2.connect("dbname=movies_aaron user = aniskin")
conn = psycopg2.connect("dbname=movies user = amniskin")
cur = conn.cursor()
cur.execute("SELECT * FROM bacon_numbers;")
bacon_numbers = cur.fetchall()
if len(bacon_numbers) == 0:
    # First to set Kevin Bacon's ID number. This could be done by checking every time, but since we know his ID won't change, we don't have to worry about that.
    bacon = 2720
    cur.execute("SELECT * FROM movies_actors;")
    movies_actors = cur.fetchall()
    cur.execute("DELETE FROM new_movies_for_bacon_numbers;")
    cur.execute("SELECT * FROM actors;")
    actors = cur.fetchall()
    bacon_numbers = [(actor,None,None) for actor,i in actors]
    ###  Here, I'm making an array of actors. Each actor will have three attributes:
    ######  0. actor ID (which is also the actor's index + 1 in the actors array)
    ######  1. current minimal distance
    ######  2. The closest intermediate through which the shortest distance is.
    bacon_numbers[bacon - 1] = (bacon_numbers[bacon-1][0], 0, bacon)
    new_movies = [x for (x,y) in movies_actors if y == bacon]
    vis_movies = set(new_movies)
    vis_actors = [bacon]
    new_edges = [(bacon, y) for (x,y) in movies_actors if x in new_movies and y != bacon]
    count = 0
    while len(new_edges) > 0:
        count = count + 1
        new_actors = []
        for (old, new) in new_edges:
            bacon_numbers[new - 1] = (bacon_numbers[new - 1][0], count, old)
            vis_actors.append(new)
            new_actors.append(new)
        new_movies = [(mov, actor) for (mov,actor) in movies_actors if mov not in vis_movies and actor in new_actors]
        new_edges = []
        for (mov, old) in new_movies:
            if mov not in vis_movies:
                tmp = [(old, new) for (m, new) in movies_actors if m == mov and new not in vis_actors]
                for old,new in tmp:
                    vis_actors.append(new)
                new_edges.extend(tmp)
                vis_movies.add(mov)
    with open('bacon_numbers.csv', 'w', newline='') as bn:
        a = csv.writer(bn, delimiter=',')
        data = [('actor_id', 'bacon_number', 'intermediary')]
        data.extend(bacon_numbers)
        a.writerows(data)
    # Commit the changes to the database and close the cursor and connection to the DB
    cur.executemany("INSERT INTO bacon_numbers VALUES(%s, %s, %s)", bacon_numbers)
    conn.commit()

cur.close()
conn.close()
