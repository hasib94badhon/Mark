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
import datetime

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
  
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASSWORD = ''
DB_DATABASE = 'registration'

   
app = Flask(__name__)
CORS(app)
# MySQL database configuration


# Create an instance of MySQLConnector
db_connector = MySQLConnector(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE)

# Create an instance of DataRetriever
data_retriever = DataRetriever(db_connector)

@app.route('/',methods=['GET', 'POST'])
def get_data():
    # Retrieve data from the database
    data = data_retriever.get_data_from_db()
    
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
        query = """SELECT users.name, users.cat_id, users.description, users.location, cat.cat_name, users.photo 
            FROM users
            LEFT JOIN cat ON users.cat_id = cat.cat_id
            WHERE users.phone = %s"""
        cursor.execute(query, (phone,))
        result = cursor.fetchone()
        
        if result:
            photos = result[5].split(',') if result[4] else []
            return jsonify({
                "name": result[0],
                "category": result[1],
                "description": result[2],
                "location": result[3],
                "cat_id":result[4],
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
    type = request.form.get('type')
    images = request.files.getlist('images')

    connection = db_connector.connect()
    if connection is None:
        return jsonify({"success": False, "message": "Failed to connect to the database"}), 500

    cursor = connection.cursor()
    try:
        # Fetch current user data
        cursor.execute("SELECT user_id, name, category, description, location, photo FROM users WHERE phone = %s", (phone,))
        user = cursor.fetchone()
        if not user:
            return jsonify({"success": False, "message": "User not found"}), 404

        user_id = user[0]
        # Update fields if provided, otherwise retain current values
        updated_name = name if name else user[1]
        updated_category = category if category else user[2]
        updated_description = description if description else user[3]
        updated_location = location if location else user[4]

        # Handle image URLs
        existing_image_urls = user[5].split(',') if user[5] else []
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

            new_image_urls.insert(0, image_url)

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

        # Check and update/insert data into the service or shops table
        if type == 'Service':
            check_query = "SELECT COUNT(*) FROM service WHERE user_id = %s"
            update_query = """
            UPDATE service
            SET name = %s, phone = %s, category = %s, description = %s, location = %s, photo = %s
            WHERE user_id = %s
            """
            insert_query = """
            INSERT INTO service (user_id, name, phone, category, description, location, photo)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
        elif type == 'Shops':
            check_query = "SELECT COUNT(*) FROM shops WHERE user_id = %s"
            update_query = """
            UPDATE shops
            SET name = %s, phone = %s, category = %s, description = %s, location = %s, photo = %s
            WHERE user_id = %s
            """
            insert_query = """
            INSERT INTO shops (user_id, name, phone, category, description, location, photo)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
        else:
            return jsonify({"error": "Invalid type provided"}), 400

        cursor.execute(check_query, (user_id,))
        if cursor.fetchone()[0] > 0:
            # Update existing record
            cursor.execute(update_query, (updated_name, phone, updated_category, updated_description, updated_location, updated_image_urls_str, user_id))
        else:
            # Insert new record
            cursor.execute(insert_query, (user_id, updated_name, phone, updated_category, updated_description, updated_location, updated_image_urls_str))
        
        connection.commit()

        return jsonify({"success": True, "image_urls": updated_image_urls_str})
    except Exception as e:
        connection.rollback()
        print(f"Error: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500
    finally:
        cursor.close()
        connection.close()

# Set up logging

import logging

# Set up logging
logging.basicConfig(level=logging.DEBUG)

@app.route('/post_data', methods=['POST'])
def post_data():
    try:
        logging.debug("Received request: %s", request.data)

        # Parse form data
        post_phone = request.form.get('post_phone')
        post_cat = request.form.get('post_cat')
        description = request.form.get('description')
        media_files = request.files.getlist('media')

        logging.debug("Parsed form data: post_phone=%s, post_cat=%s, description=%s, media_files=%s", post_phone, post_cat, description, media_files)

        if not post_phone or not post_cat or not description:
            return jsonify({"success": False, "message": "Missing required fields"}), 400

        media_urls = []
        post_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        # FTP upload
        try:
            ftp = FTP(FTP_HOST)
            ftp.login(FTP_USER, FTP_PASS)
            ftp.cwd(FTP_DIRECTORY)

            for media in media_files:
                filename = f"{post_phone}_{media.filename}"
                media_url = f"https://aarambd.com/upload/{filename}"

                with media.stream as file:
                    ftp.storbinary(f'STOR {filename}', file)

                media_urls.append(media_url)

            ftp.quit()
            logging.debug("FTP upload successful: media_urls=%s", media_urls)
        except Exception as e:
            logging.error("FTP error: %s", str(e))
            return jsonify({"success": False, "message": f"FTP error: {str(e)}"}), 500

        # Update user photo data
        try:
            # Fetch current user data
            connection = db_connector.connect()
            cursor = connection.cursor()

            cursor.execute("SELECT photo FROM users WHERE phone = %s", (post_phone,))
            user = cursor.fetchone()
            if not user:
                cursor.close()
                connection.close()
                return jsonify({"success": False, "message": "User not found"}), 404

            # Combine existing and new image URLs
            existing_photo_urls = user[0].split(',') if user[0] else []
            updated_photo_urls = existing_photo_urls + media_urls
            updated_photo_str = ','.join(updated_photo_urls)

            # Update user data in the database
            update_query = """
            UPDATE users
            SET photo = %s
            WHERE phone = %s
            """
            cursor.execute(update_query, (updated_photo_str, post_phone))
            connection.commit()

            cursor.close()
            connection.close()

            logging.debug("User photo update successful: phone=%s", post_phone)
        except Exception as e:
            logging.error("Database error: %s", str(e))
            return jsonify({"success": False, "message": f"Database error: {str(e)}"}), 500

        # Database insertion for post data
        try:
            connection = db_connector.connect()
            cursor = connection.cursor()

            insert_query = """
            INSERT INTO post (post_phone, post_cat, description, media, post_time)
            VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(insert_query, (post_phone, post_cat, description, ','.join(media_urls), post_time))
            connection.commit()

            post_id = cursor.lastrowid

            cursor.close()
            connection.close()

            logging.debug("Database insertion successful: post_id=%s", post_id)
            return jsonify({"success": True, "message": "Post created successfully", "post_id": post_id})
        except Exception as e:
            logging.error("Database error: %s", str(e))
            return jsonify({"success": False, "message": f"Database error: {str(e)}"}), 500

    except Exception as e:
        logging.error("Unexpected error: %s", str(e))
        return jsonify({"success": False, "message": f"Unexpected error: {str(e)}"}), 500







@app.route('/get_categories_name', methods=['GET'])
def get_categories_name():
    connection = db_connector.connect()
    if connection is None:
        return jsonify({"success": False, "message": "Failed to connect to the database"}), 500

    cursor = connection.cursor()
    try:
        cursor.execute("SELECT cat_id, cat_name FROM cat")  # Ensure this query matches your schema
        categories = cursor.fetchall()

        # Debugging: Print the structure of categories
        print(f"Categories fetched: {categories}")

        if not categories:
            return jsonify({"success": False, "message": "No categories found"}), 404

        # Handle data according to the actual structure
        return jsonify({'categories': [{"cat_id": cat['cat_id'], "cat_name": cat['cat_name']} for cat in categories]})

    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500
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
    HTTP_BASE_URL = "http://aarambd.com/cat logo" 
    if request.method == 'GET':
        connection = None
        try:
            connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
            with connection.cursor(pymysql.cursors.DictCursor) as cursor:
                # Fetch categories and their counts
                sql_query = '''SELECT c.cat_id,c.cat_name, c.cat_logo,s.cat_id, COUNT(s.service_id) AS count FROM service s
                JOIN cat c ON s.cat_id = c.cat_id GROUP BY c.cat_name, c.cat_logo'''
                cursor.execute(sql_query)
                categories_data = cursor.fetchall()

                # Fetch all service information
                cursor.execute('''SELECT s.service_id, c.cat_name, u.user_id,u.name,u.phone,u.location,u.photo
                FROM service s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id''')
                all_users_data = cursor.fetchall()

                # Update photo path to include the full HTTP URL
                for user in all_users_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = user['photo']

            # Prepare category count data
            sep_category_count = []
            for category in categories_data:
                category['cat_logo'] = f"{HTTP_BASE_URL}/{category['cat_logo']}" if category['cat_logo'] else None
                sep_category_count.append(
                    {"cat_id": str(category['cat_id']),"name": category['cat_name'], "count": category['count'],'photo':category['cat_logo']})

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
    HTTP_BASE_URL = "http://aarambd.com/cat logo" 
    if request.method == 'GET':
        connection = None
        try:
            connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
            with connection.cursor(pymysql.cursors.DictCursor) as cursor:
                # Fetch categories and their counts
                sql_query = '''SELECT c.cat_id,c.cat_name, c.cat_logo, COUNT(s.shop_id) AS count 
                               FROM shops s
                               JOIN cat c ON s.cat_id = c.cat_id 
                               GROUP BY c.cat_name, c.cat_logo'''
                cursor.execute(sql_query)
                categories_data = cursor.fetchall()

                # Fetch all service information
                cursor.execute('''SELECT s.shop_id, c.cat_name, c.cat_logo, u.user_id, u.name, u.phone, u.location, u.photo
                                  FROM shops s
                                  JOIN cat c ON s.cat_id = c.cat_id
                                  JOIN users u ON s.user_id = u.user_id''')
                all_users_data = cursor.fetchall()

                # Update photo path to include the full HTTP URL
                for user in all_users_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = user['photo'].split(",")

            # Prepare category count data
            sep_category_count = []
            for category in categories_data:
                category['cat_logo'] = f"{HTTP_BASE_URL}/{category['cat_logo']}" if category['cat_logo'] else None
                sep_category_count.append(
                    {"cat_id": str(category['cat_id']),"name": category['cat_name'], "count": category['count'], 'photo': category['cat_logo']})

            return jsonify({'category_count': sep_category_count, 'shops_information': all_users_data})

        except pymysql.MySQLError as e:
            print(f"Database error: {e}")
            return jsonify({"error": str(e)}), 500
        except Exception as e:
            print(f"General error: {e}")
            return jsonify({"error": str(e)}), 500
        finally:
            if connection:
                connection.close()




@app.route('/get_category_and_counts_all_info', methods=['GET','POST'])
def get_category_and_counts_all_info():
    if request.method == 'GET' or request.method == 'POST':
        # Fetch unique categories and their counts from the users table
        connection = db_connector.connect()
        cursor = connection.cursor()
        try:
            cursor.execute('''SELECT c.cat_id,c.cat_name,COUNT(u.cat_id) AS count FROM users u
                JOIN cat c ON u.cat_id = c.cat_id GROUP BY c.cat_name''')
            category_counts = cursor.fetchall()
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()

        # Separate category name and count
        separated_category_counts = []
        for cat_id, cat_name,count in category_counts:
            connection = db_connector.connect()
            cursor = connection.cursor()
            update_query = """
                UPDATE cat SET user_count = %s WHERE cat_id = %s
                """
            cursor.execute(update_query, (count, cat_id))
            connection.commit()


            separated_category_counts.append({"cat_id": cat_id, "cat_name": cat_name,"count":count})
        
        
            


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
                sql_query_service = '''SELECT c.cat_id,c.cat_name, c.cat_logo,s.cat_id, COUNT(s.service_id) AS count FROM service s
                JOIN cat c ON s.cat_id = c.cat_id GROUP BY c.cat_name, c.cat_logo'''
                cursor.execute(sql_query_service)
                service_count = cursor.fetchall()
                
                for service in service_count:
                    service['cat_id'] =str(service['cat_id'])
                
               
                # Fetch all service information
                cursor.execute('''SELECT s.service_id, c.cat_name, u.user_id,u.name,u.phone,u.location,u.photo
                FROM service s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id''')
                
                all_service_data = cursor.fetchall()

                # Fetch categories and their counts from shops table
                sql_query_shops ='''SELECT c.cat_id,c.cat_name, c.cat_logo, COUNT(s.shop_id) AS count 
                               FROM shops s
                               JOIN cat c ON s.cat_id = c.cat_id 
                               GROUP BY c.cat_name, c.cat_logo'''
                cursor.execute(sql_query_shops)
                shops_count = cursor.fetchall()

                for shops in shops_count:
                    shops['cat_id'] =str(shops['cat_id'])
                
                
                # Fetch all shops information
                cursor.execute('''SELECT s.shop_id, c.cat_name, c.cat_logo, u.user_id, u.name, u.phone, u.location, u.photo
                                  FROM shops s
                                  JOIN cat c ON s.cat_id = c.cat_id
                                  JOIN users u ON s.user_id = u.user_id''')
                all_shops_data = cursor.fetchall()

                # Convert bytes to Base64 string if necessary
            for user in all_service_data:
                    
                    if 'photo' in user and user['photo']:
                        user['photo'] = user['photo']
            
            for user in all_shops_data:
                    if 'photo' in user and user['photo']:
                        user['photo'] = user['photo']

            # Interleave the service and shops data
            combined_data = []
            combined_category_count = []
            max_length = max(len(all_service_data), len(all_shops_data))
            max_cat_length = max(len(service_count),len(shops_count))

            for i in range(max_cat_length):
                if i < len(service_count):
                    combined_category_count.append(service_count[i])
                if i < len(shops_count):
                    combined_category_count.append(shops_count[i])
          
           
            for i in range(max_length):
                if i < len(all_service_data):
                    combined_data.append(all_service_data[i])
                if i < len(all_shops_data):
                    combined_data.append(all_shops_data[i])
                    
            
            # Prepare combined category count data
            # combined_category_count = service_categories_data + shops_categories_data


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
    cat_id = request.args.get('cat_id', None)
    sort_by = request.args.get('sort_by',None)
    connection = None
    try:
        connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if cat_id:
                # Fetch data for a specific category
                base_query = '''
                SELECT s.service_id, c.cat_name, c.cat_logo,u.*
                FROM service s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                WHERE s.cat_id = %s
                '''
                params = [cat_id]
                
            else:
                # Fetch all service information
                
                base_query ='''
                SELECT s.service_id, c.cat_name, c.cat_logo, u.user_id,u.name,u.phone,u.location,u.photo,u.user_shared,u.user_viewed,u.user_called,u.user_total_post,u.user_logged_date
                FROM service s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                '''
                params = []
                # all_users_data = cursor.fetchall()
            if sort_by == 'most_viewed':
                base_query += 'ORDER BY u.user_viewed DESC'
            elif sort_by == "most_called":
                base_query += "ORDER BY u.user_called DESC"
            elif sort_by == "recent":
                base_query += "ORDER BY u.user_logged_date DESC"
            elif sort_by == 'nearby':
                #assuming location sorting is based on some distance metric
                user_location = request.args.get('user_location',None)
                if user_location:
                    base_query += "ORDER BY calculate_distance(u.location,%s)"
                    params.append(user_location)
            
            cursor.execute(base_query,params)
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
    cat_id = request.args.get('cat_id', None)
    sort_by = request.args.get('sort_by',None)
    connection = None
    try:
        connection = db_connector.connect()  # Ensure this function uses a robust method to handle connections
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:

            if cat_id:
                # Fetch data for a specific category
                base_query = '''
                SELECT s.shop_id, c.cat_name, c.cat_logo,u.*
                FROM shops s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                WHERE s.cat_id = %s
                '''
                params = [cat_id]
                # cursor.execute(sql_query, (cat_id,))
                # all_users_data = cursor.fetchall()
            else:
                # Fetch all service information
                
                base_query ='''
                SELECT s.shop_id, c.cat_name, c.cat_logo, u.user_id,u.name,u.phone,u.location,u.photo
                FROM shops s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                '''
                params = []
            if sort_by == 'most_viewed':
                base_query += 'ORDER BY u.user_viewed DESC'
            elif sort_by == "most_called":
                base_query += "ORDER BY u.user_called DESC"
            elif sort_by == "recent":
                base_query += "ORDER BY u.user_logged_date DESC"
            elif sort_by == 'nearby':
                #assuming location sorting is based on some distance metric
                user_location = request.args.get('user_location',None)
                if user_location:
                    base_query += "ORDER BY calculate_distance(u.location,%s)"
                    params.append(user_location)
            
            cursor.execute(base_query,params)
            all_users_data = cursor.fetchall()


            return jsonify({'shops_information': all_users_data})

    except pymysql.MySQLError as e:
        print(f"Database error: {e}")
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        print(f"General error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        if connection:
            connection.close()
    

@app.route('/get_data_by_category', methods=['GET'])
def get_data_by_category():
    cat_id = request.args.get('cat_id', None)
    data_type = request.args.get('data_type', None)  # 'service' or 'shops'
    sort_by = request.args.get('sort_by', None)
    user_location = request.args.get('user_location', None)  # Assuming this is used for 'nearby' sorting
    connection = None
    
    if not data_type or data_type not in ['service', 'shops']:
        return jsonify({"error": "Invalid or missing data_type parameter"}), 400

    try:
        connection = db_connector.connect()
        with connection.cursor(pymysql.cursors.DictCursor) as cursor:
            if cat_id:
                base_query = f'''
                SELECT s.{'service_id' if data_type == 'service' else 'shop_id'}, c.cat_name, c.cat_logo, u.*
                FROM {data_type} s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                WHERE s.cat_id = %s
                '''
                params = [cat_id]
            else:
                base_query = f'''
                SELECT s.{'service_id' if data_type == 'service' else 'shop_id'}, c.cat_name, c.cat_logo, u.*
                FROM {data_type} s
                JOIN cat c ON s.cat_id = c.cat_id
                JOIN users u ON s.user_id = u.user_id
                '''
                params = []

            if sort_by == 'most_viewed':
                base_query += ' ORDER BY u.user_viewed DESC'
            elif sort_by == 'most_called':
                base_query += ' ORDER BY u.user_called DESC'
            elif sort_by == 'recent':
                base_query += ' ORDER BY u.user_logged_date DESC'
            elif sort_by == 'nearby' and user_location:
                # Assuming location sorting is based on some distance metric
                base_query += ' ORDER BY calculate_distance(u.location, %s)'
                params.append(user_location)

            cursor.execute(base_query, params)
            all_data = cursor.fetchall()
            
            for cat in all_data:
                cat['cat_id'] = str(cat['cat_id'])


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


@app.route('/get_service_or_shop_data', methods=["GET"])
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


@app.route('/update_cat_data', methods=["GET","POST"])
def update_cat_data():
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


@app.route('/get_most_viewed_post', methods=['GET'])
def get_viewed_data():
    category = request.args.get('cat_id', None)
    data_type = request.args.get('data_type', None)
    if request.method == 'GET':
        # Fetch user data from the users table
        connection = db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        try:
            cursor.execute("SELECT cat_id,post_viewed,post_liked FROM post GROUP BY post_viewed")
            view_data = cursor.fetchall()
            
            sorted_view_data = []
            for view in view_data:
                sorted_view_data.append(view['post_viewed'])
            
            sorted_view_data.sort()
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()
        return jsonify({"viewed_data":view_data})

@app.route('/get_most_liked_post', methods=['GET'])
def get_liked_data():
    category = request.args.get('cat_id', None)
    data_type = request.args.get('data_type', None)
    if request.method == 'GET':
        # Fetch user data from the users table
        connection = db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        try:
            cursor.execute("SELECT cat_id,post_viewed,post_liked,post_time FROM post GROUP BY post_liked desc")
            view_data = cursor.fetchall()
            
            sorted_view_data = []
            for view in view_data:
                sorted_view_data.append(view['post_viewed'])
            
            sorted_view_data.sort(reverse='True')
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()
        return jsonify({"viewed_data":view_data})

@app.route('/get_most_updated_post', methods=['GET'])
def get_updated_data():
    category = request.args.get('cat_id', None)
    data_type = request.args.get('data_type', None)
    if request.method == 'GET':
        # Fetch user data from the users table
        connection = db_connector.connect()
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        try:
            cursor.execute("SELECT post_time,cat_id,post_viewed,post_liked,post_id FROM post GROUP BY post_id desc")
            view_data = cursor.fetchall()
            
            # sorted_view_data = []
            # total_data =[]
            # for view in view_data:
            #         sorted_view_data.append(view['post_time'])
            
            # sorted_view_data.sort(reverse=True)

            # for j in sorted_view_data:
            #     for k in view_data:
            #         if j == k['post_time']:
            #             total_data.append({'post_id':k['post_id'],'post_viewed':k['post_viewed'],'post_liked':k['post_liked'],'post_time':j,'cat_id':k['cat_id']})
           

                
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
            cursor.close()
            connection.close()
        return jsonify({"viewed_data":view_data})
    

@app.route('/get_total_post_on_users', methods=['GET','POST'])
def get_total_post_on_users():
    if request.method == 'GET' or request.method == 'POST':
        # Fetch unique categories and their counts from the users table
        connection = db_connector.connect()
        cursor = connection.cursor()
        
        try:
            cursor.execute('''SELECT p.user_id,COUNT(p.post_id) AS count FROM post p
                    JOIN users u ON u.user_id = p.user_id GROUP BY u.user_id''')
            
            post_counts = cursor.fetchall()
            seperated_post_counts = []
            for user_id,counts in post_counts:
                cursor = connection.cursor()
                sql = f"""UPDATE users set user_total_post = %s WHERE user_id = %s"""
                cursor.execute(sql, (counts,user_id))
                connection.commit()
                seperated_post_counts.append({'user_id':user_id,'post_counts':counts})

        
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        finally:
                cursor.close()
                connection.close()
        return jsonify({'post_counts':seperated_post_counts})



@app.route('/get_most_used_category', methods=['GET'])
def get_most_used_category():
    if request.method == 'GET':
        connection = db_connector.connect()
        cursor = connection.cursor()
        
        try:
            # Fetch category usage from users and join with cat_table to get category details
            cursor.execute("""
                SELECT u.cat_id, c.cat_name, c.cat_logo, SUM(u.user_viewed) AS total_views
                FROM users u
                JOIN cat c ON u.cat_id = c.cat_id
                GROUP BY u.cat_id
                ORDER BY total_views DESC
            """)
            most_used_categories = cursor.fetchall()
            
            
            if most_used_categories:
                response = []
                for category in most_used_categories:
                    response.append({
                        'cat_id': category[0],
                        'cat_name': category[1],
                        'cat_logo': category[2],
                        'total_views': category[3]
                    })
                return jsonify({"most_used_cat":response})
            else:
                return jsonify({"error": "No category usage data found"}), 404
        
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        
        finally:
            cursor.close()
            connection.close()

@app.route('/get_today_post', methods=['GET'])
def get_today_post():
    if request.method == 'GET':
        connection = db_connector.connect()
        cursor = connection.cursor()
        
        try:
            # Fetch category usage from users and join with cat_table to get category details
            cursor.execute("""
                SELECT u.name,u.phone,c.cat_name,p.* 
                FROM post p 
                JOIN cat c ON c.cat_id = p.cat_id
                JOIN users u ON u.user_id = p.user_id
                GROUP BY p.post_id DESC
            """)
            update_post = cursor.fetchall()
            
            
            if update_post:
                response = []
                for category in update_post:
                    response.append({
                        'name': category[0],
                        'phone': category[1],
                        'category': category[2],
                        'post_id':category[3],
                        'description': category[6],
                        'photo':category[7],
                        'like':category[8],
                        'view':category[9],
                        'share':category[10],
                        'time':category[11]

                    })
                return jsonify({"most_update_post":response})
            else:
                return jsonify({"error": "No category usage data found"}), 404
        
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        
        finally:
            cursor.close()
            connection.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)
