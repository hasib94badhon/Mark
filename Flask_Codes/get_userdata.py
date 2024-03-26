from flask import Flask, jsonify,request
from json import *
from flask_mysqldb import MySQL
from _mysql_connector import *
import re
import pymysql
from flask_cors import CORS
import time

class MySQLConnector:
    def __init__(self, host, user, password, database):
        self.host = host
        self.user = user
        self.password = password
        self.database = database

    def connect(self):
        return pymysql.connect(host=self.host, user=self.user, password=self.password, database=self.database)

class DataRetriever:
    def __init__(self, db_connector):
        self.db_connector = db_connector

    def get_data_from_db(self):
        connection = self.db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        cursor.execute("SELECT * FROM users")
        data = cursor.fetchall()
        connection.close()
        return data
  

   
app = Flask(__name__)
CORS(app)
# MySQL database configuration
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASSWORD = ''
DB_DATABASE = 'registration'

# Create an instance of MySQLConnector
db_connector = MySQLConnector(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE)

# Create an instance of DataRetriever
data_retriever = DataRetriever(db_connector)

@app.route('/',methods=['GET', 'POST'])
def get_data():
    # Retrieve data from the database
    data = data_retriever.get_data_from_db()
    print(data)
    # Return data as JSON
    return jsonify({'data':data})



@app.route('/add', methods=['POST'])
def add_data_to_db():
    if request.method == 'POST':
        # if request.content_type != 'application/json':
        #     return jsonify({"error": "Request Content-Type must be 'application/json'"}), 400
        
        try:
            data = request.get_json()
            print("Received Data:", data)  # Print the received data for debugging
            phone = data['phone']
            password = data['password']
        except Exception as e:
            return jsonify({"error": f"Failed to parse JSON data: {str(e)}"}), 400

        # Insert data into the database
        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute("INSERT INTO reg (phone, password) VALUES (%s, %s)", (phone, password))
            connection.commit()
            reg_id = cursor.lastrowid  # Get the auto-generated reg_id
            return jsonify({"reg_id": reg_id, "message": "Data added successfully"})
        except Exception as e:
            connection.rollback()
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()

@app.route('/login', methods=['POST'])
def login_user():
    if request.method == 'POST':
        try:
            data = request.get_json()
            print("Received Data:", data)  # Print the received data for debugging
            phone = data['phone']
            password = data['password']
        except Exception as e:
            return jsonify({"error": f"Failed to parse JSON data: {str(e)}"}), 400

        # Check if the user exists in the database
        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute("SELECT * FROM reg WHERE phone = %s AND password = %s", (phone, password))
            user = cursor.fetchone()
            if user:
                # User found, return success message
                return jsonify({"message": "Login successful", "user": user})
            else:
                # User not found, return error message
                return jsonify({"error": "Invalid phone number or password"}), 401
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()
if __name__ == '__main__':
    app.run(debug=True)
