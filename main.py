import mysql.connector
import sys

# connect to db as user 'api'
try:
    db  = mysql.connector.connect(
        host='localhost',
        user='api',
        database='CSC315FinalFall2020'
    )
except:
    print('Error connecting to database.')
    sys.exit(1)

cursor = db.cursor()

def f(id):
    try:
        cursor.execute('SELECT * FROM User WHERE uid=%s;' % id)
    except:
        return f'Error: {cursor}'

    return f'Success: {cursor}'

f(2)

# print results
for i in cursor: print(i)

# db.commit()
db.close()