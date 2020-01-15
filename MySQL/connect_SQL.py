import pymysql

conn = pymysql.connect(host = 'localhost', user = 'root', password = 'Tokeikaonly1', port = 3306, db = 'dnf')
cursor = conn.cursor()
SQL = '''INSERT INTO CN_avatar(name, type, model) VALUES ('test', 'test', 'test')'''
try:
    cursor.execute(SQL)
    conn.commit()
except:
    conn.rollback()
conn.close()