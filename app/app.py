import pymysql
from flask import Flask, render_template
import os

app = Flask(__name__)


class Database:
    def __init__(self):
        host = os.getenv('DB_HOST')
        port = int(os.getenv('DB_PORT'))
        user = os.getenv('DB_USER')
        password = os.getenv('DB_PASS')
        db = os.getenv('DB_NAME_DEV')

        self.con = pymysql.connect(host=host, port=port,
                                   user=user, password=password,
                                   db=db, charset='utf8mb4',
                                   cursorclass=pymysql.cursors.DictCursor)
        self.cur = self.con.cursor()
        self.con.ping(reconnect=True)

    def list_first_fifty_models(self):
        self.cur.execute("SELECT id, submission_id FROM model LIMIT 50")
        result = self.cur.fetchall()

        return result


@app.route("/")
def index():
    try:
        return render_template('index.html')
    except ConnectionAbortedError as e:
        print(str(e))
        return render_template('error.html')


@app.route("/models")
def models():
    def db_query():
        db = Database()
        list_models = db.list_first_fifty_models()

        return list_models

    res = db_query()
    return render_template('model_list.html', result=res, content_type='application/json')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
