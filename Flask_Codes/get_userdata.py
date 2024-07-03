import base64
from flask import Flask, jsonify,request
from json import *
from flask_mysqldb import MySQL
from _mysql_connector import *
import re
import pymysql
from flask_cors import CORS
import time
from mysql.connector import Error

import pymysql.cursors
import requests
from ftplib import FTP

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
            print(user)
            if user:
                # User found, get the necessary details
                reg_id = user[0]  # Assuming reg_id is the first element in the tuple
                name = user[1]    # Assuming name is the second element in the tuple
                user_phone = user[2]  # Assuming phone is the third element in the tuple

                # Check if the user already exists in the users table
                cursor.execute("SELECT * FROM users WHERE phone = %s", (user_phone,))
                existing_user = cursor.fetchone()
                if existing_user:
                    print("User already exists in users table.")
                else:
                    # User does not exist in users table, insert the data
                    try:
                        cursor.execute("INSERT INTO users (reg_id, name, phone) VALUES (%s, %s, %s)", (reg_id, name, user_phone))
                        connection.commit()  # Commit the transaction
                        print("User inserted into users table.")
                    except Exception as insert_error:
                        return jsonify({"error": f"Failed to insert user into users table: {str(insert_error)}"}), 500

                return jsonify({"message": "Login successful", "user": {"reg_id": reg_id, "name": name, "phone": user_phone}})
            else:
                # User not found, return error message
                return jsonify({"error": "Invalid phone number or password"}), 401
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()


@app.route('/check_phone', methods=['POST'])
def check_phone():
    if request.method == 'POST':
        try:
            data = request.get_json()
            phone = data['phone']
            # You can ignore the password or set any necessary value
        except Exception as e:
            return jsonify({"error": f"Failed to parse JSON data: {str(e)}"}), 400

        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute("SELECT * FROM reg WHERE phone = %s", (phone,))
            user = cursor.fetchone()
            if user:
                return jsonify({"exists": True})
            else:
                return jsonify({"exists": False})
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()


@app.route('/get_user_by_phone', methods=['GET'])
def get_user_by_phone():
    try:
        phone = request.args.get('phone')
        if not phone:
            return jsonify({"error": "Phone number is required"}), 400
    except Exception as e:
        return jsonify({"error": f"Failed to parse request: {str(e)}"}), 400

    connection = db_connector.connect()
    if connection is None:
        return jsonify({"error": "Failed to connect to the database"}), 500
    
    cursor = connection.cursor()
    try:
        query = "SELECT name, category, description, location, photo FROM users WHERE phone = %s"
        cursor.execute(query, (phone,))
        result = cursor.fetchone()
        print(result)
        if result:
            photos = result[4].split(',') if result[4] else []
            return jsonify({
                "name": result[0],
                "category": result[1],
                "description": result[2],
                "location": result[3],
                "photo": photos
            })
        else:
            return jsonify({"success": False, "message": "User not found"}), 404
    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500
    finally:
        cursor.close()
        connection.close()


FTP_HOST = '89.117.27.223'
FTP_USER = 'u790304855'
FTP_PASS = 'Abra!!@@12'
FTP_DIRECTORY = '/domains/aarambd.com/public_html/upload'
@app.route('/update_user_profile', methods=['POST'])
def update_user_profile():
    name = request.form.get('name')
    phone = request.form.get('phone')
    category = request.form.get('category')
    description = request.form.get('description')
    location = request.form.get('location')
    images = request.files.getlist('images')

    connection = db_connector.connect()
    if connection is None:
        return jsonify({"success": False, "message": "Failed to connect to the database"}), 500




    cursor = connection.cursor()
    try:
        # Fetch current user data
        cursor.execute("SELECT name, category, description, location, photo FROM users WHERE phone = %s", (phone,))
        user = cursor.fetchone()
        if not user:
            return jsonify({"success": False, "message": "User not found"}), 404

        # Update fields if provided, otherwise retain current values
        updated_name = name if name else user[0]
        updated_category = category if category else user[1]
        updated_description = description if description else user[2]
        updated_location = location if location else user[3]

        # Handle image URLs
        existing_image_urls = user[4].split(',') if user[4] else []
        new_image_urls = []

        # Establish FTP connection
        ftp = FTP(FTP_HOST, FTP_USER, FTP_PASS)
        ftp.cwd(FTP_DIRECTORY)  # Change directory on the FTP server

        for image in images:
            image_filename = f"{phone}_{image.filename}"
            image_url = f"https://aarambd.com/upload/{image_filename}"  # Assuming this is how you will access the image

            # Upload image to FTP server
            with image.stream as file:
                ftp.storbinary(f'STOR {image_filename}', file)

            new_image_urls.insert(0,image_url)

        # Combine existing and new image URLs
        updated_image_urls = new_image_urls + existing_image_urls
        updated_image_urls_str = ','.join(updated_image_urls)

        # Update user data in the database
        query = """
        UPDATE users
        SET name = %s, category = %s, description = %s, location = %s, photo = %s
        WHERE phone = %s
        """
        cursor.execute(query, (updated_name, updated_category, updated_description, updated_location, updated_image_urls_str, phone))
        connection.commit()
        return jsonify({"success": True, "image_urls": updated_image_urls})
    except Exception as e:
        connection.rollback()
        print(f"Error: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500
    finally:
        cursor.close()
        connection.close()



@app.route('/get_categories_name',methods=['GET'])    
def get_categories():
    try:
        connection = db_connector.connect()
        cursor = connection.cursor()
        cursor.execute("SELECT cat_name FROM cat ORDER BY cat_name")
        categories = cursor.fetchall()
        return jsonify({'categories':[category[0] for category in categories]})  
    except Error as e:
        return ({'error':str(e)}),500
    finally:
        if connection:
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
