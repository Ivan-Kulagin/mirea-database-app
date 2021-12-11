from flask import Flask, render_template, request, redirect, url_for, send_from_directory
from flask_mysqldb import MySQL
import os
import config

app = Flask(__name__)

app.config['MYSQL_USER'] = config.username
app.config['MYSQL_PASSWORD'] = config.password
app.config['MYSQL_HOST'] = config.db_host
app.config['MYSQL_DB'] = config.db_name
app.config['MYSQL_CURSORCLASS'] = config.db_cursor

db_tables = f'Tables_in_{config.db_name}'
white_list = config.white_listed_tables
root_table = config.root_table

mysql = MySQL(app)

data = None
headings = None
tables = None
privilege = 0  # 0 - unauthorized, 1 - authorized, 2 - admin


@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')


@app.route('/')
def redirect_to_root_table():
    return redirect(url_for('index', table=root_table))


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == "GET":
        return render_template('auth.html', auth_mode=0)
    if request.method == "POST":
        global privilege
        cursor = mysql.connection.cursor()

        # Creds
        user = request.form['username']
        email = request.form['email']
        password = request.form['password']

        # User validation
        if len(email) > 2 and len(user) > 3 and len(password) > 5:
            # Check if exists
            cursor.execute("SELECT * FROM Users")
            user_table = cursor.fetchall()
            users = [user['UserName'] for user in user_table]
            emails = [email['UserEmail'] for email in user_table]

            if email in emails:
                return render_template('auth.html', auth_mode=0, valid_res='This email already exists')

            if user in users:
                return render_template('auth.html', auth_mode=0, valid_res='This user already exists')

        else:
            return render_template('auth.html', auth_mode=0, valid_res='Invalid data')

        # Add new User
        query = f"INSERT INTO Users VALUES(DEFAULT, '{user}', '{email}', '{password}', 'user')"
        cursor.execute(query)
        mysql.connection.commit()
        cursor.close()
        privilege = 1
        return redirect_to_root_table()


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == "GET":
        return render_template('auth.html', auth_mode=1)
    if request.method == "POST":
        global privilege
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM Users")
        user_table = cursor.fetchall()

        users = [(user['UserName'], user['UserPassword']) for user in user_table]
        user = request.form['username']
        password = request.form['password']
        if (user, password) in users:
            cursor.execute(f"SELECT UserRole FROM Users WHERE UserName = '{user}'")
            role = cursor.fetchone()['UserRole']
            if role == 'user':
                privilege = 1
            elif role == 'admin':
                privilege = 2
            else:
                privilege = 0

            return redirect_to_root_table()
        else:
            return render_template('auth.html', auth_mode=1, valid_res='Access Denied. Incorrect username or password')


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    global privilege
    if privilege > 0:
        privilege = 0
        return render_template('auth.html', auth_mode=1,
                               valid_res='You are logged out. Enter your credentials to log in.')
    else:
        return render_template('auth.html', auth_mode=1,
                               valid_res='Please log in first.')


@app.route('/<table>', methods=['GET', 'POST'])
def index(table):
    if table == "register":
        redirect(url_for('register'))
    elif table == "login":
        redirect(url_for('login'))
    if privilege == 0:
        return render_template('auth.html', auth_mode=1, valid_res='Please log in first')

    global data, headings, tables
    if request.method == 'GET':
        cursor = mysql.connection.cursor()
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        cursor.execute(f"SELECT * FROM {table}")
        data = cursor.fetchall()
        try:
            headings = list(data[0].keys())
        except IndexError:
            return redirect_to_root_table()

        return render_template('tables.html', headings=headings, data=data, table=table, tables=tables,
                                privilege=privilege, db_tables=db_tables, white_list=white_list)

    if request.method == 'POST' and privilege > 1:
        values = []
        for header in headings:
            values.append(request.form[header])
        values.pop(0)
        values = ", ".join(f'"{item}"' for item in values)
        query = f"INSERT INTO {table} VALUES (0, {values})"
        print(query)

        cur = mysql.connection.cursor()
        try:
            cur.execute(query)
        except Exception as error:
            print(error)
            return redirect(url_for('index', table=table))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('index', table=table))


@app.route('/delete/<table>/<id>', methods=['GET', 'POST'])
def delete(table, id):
    if privilege != 2:
        return render_template('auth.html', auth_mode=1, valid_res='Please log in as admin first')
    try:
        query = f"DELETE FROM {table} WHERE {headings[0]} = {id}"
    except TypeError as error:
        print(error)
        return redirect(url_for('index', table=table))
    print(query)
    cur = mysql.connection.cursor()
    try:
        cur.execute(query)
    except Exception as error:
        print(error)
        return redirect(url_for('index', table=table))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('index', table=table))


@app.route('/update/<table>/<id>/<field_value>', methods=['GET', 'POST'])
def update(table, id, field_value):
    if privilege != 2:
        return render_template('auth.html', auth_mode=1, valid_res='Please log in as admin first')
    if request.method == 'GET':
        cur = mysql.connection.cursor()
        try:
            query = f"SELECT * FROM {table} WHERE {headings[0]} = {id}"
        except TypeError as error:
            print(error)
            return redirect(url_for('index', table=table))
        try:
            cur.execute(query)
        except Exception as error:
            print(error)
            return redirect(url_for('index', table=table))

        row = cur.fetchone()
        try:
            column = list(row.keys())[list(row.values()).index(field_value)]
        except ValueError as error:
            print(error)
            return render_template('tables.html', headings=headings, data=data, table=table, tables=tables, row=row,
                                   id=id, field_value=field_value, privilege=privilege)
        mysql.connection.commit()
        cur.close()
        return render_template('tables.html', headings=headings, data=data, table=table, tables=tables, row=row, id=id,
                               field_value=field_value, column=column, privilege=privilege)

    if request.method == 'POST':
        cur = mysql.connection.cursor()
        try:
            cur.execute(f"SELECT * FROM {table} WHERE {headings[0]} = {id}")
        except Exception as error:
            print(error)
            return redirect(url_for('index', table=table, privilege=privilege))

        keys = list(cur.fetchone().keys())
        values = []
        query_input = []
        for key in keys:
            values.append(request.form[key])
        values.pop(0)
        keys.pop(0)
        d = dict(zip(keys, values))
        for key, value in d.items():
            query_input.append(f"{key} = '{value}'")
        query = f"UPDATE {table} SET {', '.join(query_input)} WHERE {headings[0]} = {id}"
        try:
            cur.execute(query)
        except Exception as error:
            print(error)
            return redirect(url_for('index', table=table))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('index', table=table))


@app.route('/filter/<table>/<column>/<_from>/<_to>', methods=['GET', 'POST'])
def filter(table, column, _from, _to):
    if privilege == 0:
        return render_template('auth.html', auth_mode=1, valid_res='Please log in first')
    query = f"SELECT * FROM {table} WHERE {column} BETWEEN {_from} AND {_to}"
    cur = mysql.connection.cursor()
    cur.execute(query)
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('index', table=table))


@app.route('/sort/<table>/<column>/<order>', methods=['GET', 'POST'])
def sort(table, column, order):
    if privilege == 0:
        return render_template('auth.html', auth_mode=1, valid_res='Please log in first')
    global data
    query = f"SELECT * FROM {table} ORDER BY {column} {order}"
    print(query)
    cur = mysql.connection.cursor()
    cur.execute(query)
    data = cur.fetchall()
    try:
        headings = list(data[0].keys())
    except IndexError as error:
        print(error)
        return redirect(url_for('index', table=table))
    mysql.connection.commit()
    cur.close()
    return render_template('tables.html', headings=headings, data=data, table=table, tables=tables, privilege=privilege)


if __name__ == '__main__':
    app.run(debug=True)
