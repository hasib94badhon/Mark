import base64
from flask import Flask, jsonify,request
from json import *
from flask_mysqldb import MySQL
from _mysql_connector import *
import re
import pymysql
from flask_cors import CORS
import time

import pymysql.cursors

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
        cursor.execute("SELECT * FROM reg")
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
            name = data['name']
            phone = data['phone']
            password = data['password']
        except Exception as e:
            return jsonify({"error": f"Failed to parse JSON data: {str(e)}"}), 400

        # Insert data into the database
        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute("INSERT INTO reg (name,phone, password) VALUES (%s,%s, %s)", (name,phone,password))
            connection.commit()
            reg_id = cursor.lastrowid  # Get the auto-generated reg_id
            cursor.execute("INSERT INTO users (reg_id,name,phone) VALUES (%s,%s, %s)", (reg_id,name, phone))
            connection.commit()
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
                # phone = user[1]
                # print(phone)
                return jsonify({"message": "Login successful", "user": {"phone": user[1]}})
            else:
                # User not found, return error message
                return jsonify({"error": "Invalid phone number or password"}), 401
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            
            cursor.close()
            connection.close()
        

@app.route('/get_users_data', methods=['GET'])
def get_user_data():
    if request.method == 'GET':
        # Fetch user data from the users table
        connection = db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        try:
            cursor.execute("SELECT * FROM service")
            users_data = cursor.fetchall()
            print(users_data)
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()

        # Fetch data from the reg table based on the foreign key relationship
        users_with_phone_data = []
        for user in users_data:
            reg_id = user['service_id']
            connection = db_connector.connect()
            cursor = connection.cursor()
            try:
                cursor.execute("SELECT phone FROM reg WHERE reg_id = %s", (reg_id,))
                reg_data = cursor.fetchone()
                if reg_data:
                   phone = reg_data[0]  # Extract phone number from the tuple
                   user['phone'] = phone
                users_with_phone_data.append(user)
            except Exception as e:
                return jsonify({"error": str(e)}), 500
            finally:
                cursor.close()
                connection.close()

        return jsonify({"users_data": users_with_phone_data})



@app.route('/get_service_data', methods=['GET'])
def get_service_data():
    HTTP_BASE_URL = "http://aarambd.com/photo" 
    if request.method == 'GET':
        connection = None
        try:
            connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
            with connection.cursor(pymysql.cursors.DictCursor) as cursor:
                # Fetch categories and their counts
                sql_query = "SELECT category,MIN(photo) AS photo, COUNT(*) AS count FROM service GROUP BY category"
                cursor.execute(sql_query)
                categories_data = cursor.fetchall()

                # Fetch all service information
                cursor.execute("SELECT * FROM service")
                all_users_data = cursor.fetchall()

                # Update photo path to include the full HTTP URL
                for user in all_users_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = f"{HTTP_BASE_URL}/{user['photo']}"

            # Prepare category count data
            sep_category_count = []
            for category in categories_data:
                category['photo'] = f"{HTTP_BASE_URL}/{category['photo']}"
                sep_category_count.append({"name": category['category'], "count": category['count'],'photo':category['photo']})

            return jsonify({'category_count': sep_category_count, 'service_information': all_users_data})

        except pymysql.MySQLError as e:
            print(f"Database error: {e}")
            return jsonify({"error": str(e)}), 500
        except Exception as e:
            print(f"General error: {e}")
            return jsonify({"error": str(e)}), 500
        finally:
            if connection:
                connection.close()  # 

"""Get Shops Data from DB"""
@app.route('/get_shops_data', methods=['GET'])

# Define your HTTP base URL
 # Adjust this to match the actual URL structu
def get_shops_data():
    HTTP_BASE_URL = "http://aarambd.com/photo" 
    if request.method == 'GET':
        connection = None
        try:
            connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
            with connection.cursor(pymysql.cursors.DictCursor) as cursor:
                # Fetch categories and their counts
                sql_query = "SELECT category,MIN(photo) AS photo, COUNT(*) AS count FROM shops GROUP BY category"
                cursor.execute(sql_query)
                categories_data = cursor.fetchall()

                # Fetch all service information
                cursor.execute("SELECT * FROM shops")
                all_users_data = cursor.fetchall()

                # Update photo path to include the full HTTP URL
                for user in all_users_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = f"{HTTP_BASE_URL}/{user['photo']}"

            # Prepare category count data
            sep_category_count = []
            for category in categories_data:
                category['photo'] = f"{HTTP_BASE_URL}/{category['photo']}"
                sep_category_count.append({"name": category['category'], "count": category['count'],'photo':category['photo']})

            return jsonify({'category_count': sep_category_count, 'service_information': all_users_data})

        except pymysql.MySQLError as e:
            print(f"Database error: {e}")
            return jsonify({"error": str(e)}), 500
        except Exception as e:
            print(f"General error: {e}")
            return jsonify({"error": str(e)}), 500
        finally:
            if connection:
                connection.close()



@app.route('/get_category_and_counts_all_info', methods=['GET'])
def get_category_and_counts_all_info():
    if request.method == 'GET':
        # Fetch unique categories and their counts from the users table
        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute("SELECT category, COUNT(*) AS count FROM users GROUP BY category")
            category_counts = cursor.fetchall()
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()

        # Separate category name and count
        separated_category_counts = []
        for category, count in category_counts:
            separated_category_counts.append({"category_name": category, "category_count": count})
            


        # Fetch all user information
        connection = db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        try:
            cursor.execute("SELECT * FROM users")
            all_users_data = cursor.fetchall()
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()

        return jsonify({"category_counts": separated_category_counts, "all_users_data": all_users_data})



@app.route('/get_combined_data', methods=['GET'])
def get_combined_data():
    HTTP_BASE_URL = "http://aarambd.com/photo" 
    if request.method == 'GET':
        connection = None
        try:
            connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
            with connection.cursor(pymysql.cursors.DictCursor) as cursor:
                # Fetch categories and their counts from service table
                sql_query_service = "SELECT category,MIN(photo) AS photo, COUNT(*) AS count FROM service GROUP BY category"
                cursor.execute(sql_query_service)
                service_categories_data = cursor.fetchall()

                # Fetch all service information
                cursor.execute("SELECT * FROM service")
                all_service_data = cursor.fetchall()

                # Fetch categories and their counts from shops table
                sql_query_shops = "SELECT category,MIN(photo) AS photo, COUNT(*) AS count FROM shops GROUP BY category"
                cursor.execute(sql_query_shops)
                shops_categories_data = cursor.fetchall()

                # Fetch all shops information
                cursor.execute("SELECT * FROM shops")
                all_shops_data = cursor.fetchall()

                # Convert bytes to Base64 string if necessary
            for user in all_service_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = f"{HTTP_BASE_URL}/{user['photo']}"
            
            for user in all_shops_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = f"{HTTP_BASE_URL}/{user['photo']}"

            # Interleave the service and shops data
            combined_data = []
            max_length = max(len(all_service_data), len(all_shops_data))
            for i in range(max_length):
                if i < len(all_service_data):
                    combined_data.append(all_service_data[i])
                if i < len(all_shops_data):
                    combined_data.append(all_shops_data[i])

            # Prepare combined category count data
            combined_category_count = service_categories_data + shops_categories_data

            return jsonify({'category_count': combined_category_count, 'combined_information': combined_data})

        except pymysql.MySQLError as e:
            print(f"Database error: {e}")
            return jsonify({"error": str(e)}), 500
        except Exception as e:
            print(f"General error: {e}")
            return jsonify({"error": str(e)}), 500
        finally:
            if connection:
                connection.close()


@app.route('/get_service_data_by_category', methods=['GET'])
def get_service_data_by_category():
    category = request.args.get('category', None)
    connection = None
    try:
        connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if category:
                # Fetch data for a specific category
                sql_query = "SELECT * FROM service WHERE category = %s"
                cursor.execute(sql_query, (category,))
                all_users_data = cursor.fetchall()
            else:
                # Fetch all service information
                cursor.execute("SELECT * FROM service")
                all_users_data = cursor.fetchall()

           
            

            return jsonify({'service_information': all_users_data})

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if connection:
            connection.close()


@app.route('/get_shop_data_by_category',methods=['GET'])
def get_shop_data_by_category():
    category = request.args.get('category', None)
    connection = None
    try:
        connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if category:
                # Fetch data for a specific category
                sql_query = "SELECT * FROM shops WHERE category = %s"
                cursor.execute(sql_query, (category,))
                all_users_data = cursor.fetchall()
            else:
                # Fetch all service information
                cursor.execute("SELECT * FROM shops")
                all_users_data = cursor.fetchall()

            # Convert bytes to Base64 string if necessary
            for user in all_users_data:
                for key, value in user.items():
                    if isinstance(value, bytes):
                        user[key] = base64.b64encode(value).decode()

            return jsonify({'shop_information': all_users_data})

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if connection:
            connection.close()

    

@app.route('/get_service_or_shop_data',methods =["GET"])
def get_service_or_shop_data():
    service_id = request.args.get('service_id', None)
    shop_id = request.args.get('shop_id', None)
    connection = None
    try:
        connection = db_connector.connect()
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if service_id:
                # Fetch data for a service_id
                sql = "SELECT * FROM service WHERE service_id = %s"
                cursor.execute(sql, (service_id,))
                data = cursor.fetchall()
                data_key = "service_data"
            elif shop_id:
                # Fetch data for a shop_id
                sql = "SELECT * FROM shops WHERE shop_id = %s"
                cursor.execute(sql, (shop_id,))
                data = cursor.fetchall()
                data_key = "shop_data"
            else:
                # Return error if no ID is provided
                return jsonify({"error": "Please provide either a service_id or a shop_id"}), 400

            # Process data (e.g., encode binary data as base64)
            # for record in data:
            #     for key, value in record.items():
            #         if isinstance(value, bytes):
            #             record[key] = base64.b64encode(value).decode()

            return jsonify({data_key: data})

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if connection:
            connection.close()

#  used in advert_screen on flutter
@app.route('/get_data_by_category', methods=['GET'])
def get_data_by_category():
    category = request.args.get('category', None)
    data_type = request.args.get('data_type', None)  # 'service' or 'shop'
    connection = None
    
    if not data_type or data_type not in ['service', 'shops']:
        return jsonify({"error": "Invalid or missing data_type parameter"}), 400

    try:
        connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if category:
                # Fetch data for a specific category
                sql_query = f"SELECT * FROM {data_type} WHERE category = %s"
                cursor.execute(sql_query, (category,))
            else:
                # Fetch all information
                sql_query = f"SELECT * FROM {data_type}"
                cursor.execute(sql_query)

            all_data = cursor.fetchall()

            return jsonify({f'{data_type}_information': all_data})

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if connection:
            connection.close()





    
  


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)
