import psycopg2
from psycopg2 import sql
import random
import lorem
import time

# Database connection parameters
db_params = {
    'dbname': 'lab',
    'user': 'lab',
    'host': 'postgres'
}

# Connect to the database
conn = psycopg2.connect(**db_params)
cur = conn.cursor()

if False:
    cur.execute(sql.SQL("TRUNCATE TABLE alpha"))
    conn.commit()

    # Generate and insert data
    for _ in range(250000):
        time.sleep(0.001)
        alpha_id = random.randint(0, 25000)
        name = ' '.join(lorem.text().split()[:5])  # 5 random words from lorem ipsum text
        cur.execute(
            sql.SQL("INSERT INTO alpha (alpha_id, name) VALUES (%s, %s)"),
            [alpha_id, name]
        )
        conn.commit()

if True:
    cur.execute(sql.SQL("TRUNCATE TABLE beta"))
    conn.commit()

    # Execute the query
    cur.execute("SELECT DISTINCT alpha_id FROM alpha")

    # Fetch all unique alpha_ids
    unique_alpha_ids = [row[0] for row in cur.fetchall()]


    # Generate and insert data
    for _ in range(250000 * 3):
        #time.sleep(0.001)
        random_alpha_id = random.choice(unique_alpha_ids)
        beta_id = random.randint(0, 10)
        name = ' '.join(lorem.text().split()[:5])  # 5 random words from lorem ipsum text
        cur.execute(
            sql.SQL("INSERT INTO beta (beta_id, alpha_id, name) VALUES (%s, %s, %s)"),
            [beta_id, random_alpha_id, name]
        )
        conn.commit()


# Commit the changes and close the connection
conn.commit()
cur.close()
conn.close()
