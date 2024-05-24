import pandas as pd
import os
import mysql.connector
import openpyxl
from datetime import datetime
import re

from openpyxl_image_loader import SheetImageLoader
from pymysql import Error
# path = os.path.dirname(excel_path)
# df = pd.read_excel('Assorted.xlsx', sheet_name='shops')

# MySQL database connection
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="registration"
)

# cursor = mydb.cursor()
# for filename in os.listdir('downloaded_images'):
#         if filename.endswith(".png"):  # Check if the file is a JPEG image
#             user_id = filename.split('_')[1].split('.')[0]  # Extract user_id from filename (e.g., '1' from 'image_1.jpg')
#             filepath = os.path.join('downloaded_images', filename)
            
#             if int(user_id) < 11:
#                 with open(filepath, 'rb') as file:
#                     binary_data = file.read()
            
#             # SQL Query to update the image data in the service table where user_id matches
#             query = "UPDATE service SET photo = %s WHERE service_id = %s"
            
#             # Execute the query
#             cursor.execute(query, (binary_data, user_id))
#             print(f"Image {filename} updated in the database for user_id {user_id}.")
#         else:
#              break

       
            # Open the image file and read it into a binary variable
            



# SQL query to insert data
# SQL query to insert data, excluding shop_id (auto-increment) and using NOW() for the current timestamp
# sql = "INSERT INTO shops (category, business_name, address, phone, date_time) VALUES ( %s, %s, %s, %s, NOW())"
# DEFAULT_PHONE = "0000000000"  # Replace with an appropriate default value

# # Loop through the data and insert into the database
# for index, row in df.iterrows():
#     try:
#         # Check and clean the phone number
#         phone = str(row['phone']) if pd.notna(row['phone']) else DEFAULT_PHONE
#         phone = re.sub(r'[^0-9]', '   ', phone)  # Remove all non-numeric characters
        
#         if not phone.isdigit() or phone == "":
#             phone = DEFAULT_PHONE  # Set phone to default if non-numeric or empty

#         # Insert data into the database
#         cursor.execute(sql, (
#             row['category'] if pd.notna(row['category']) else None,
#             row['business_name'] if pd.notna(row['business_name']) else None,
#             row['address'] if pd.notna(row['address']) else None,
#             phone,
           
#         ))
#     except Exception as e:
#         print(f"Error inserting row {index}: {e}")

# # Commit changes and close connection
# mydb.commit()
# cursor.close()
# mydb.close()

# print("Data successfully inserted into the database.")

# path = "C:\\Users\\user\\Downloads\\photo\\die"
# counter = 1
# for filename in os.listdir(path):
#     if filename.endswith('png') or filename.endswith('jpg') or filename.endswith('jpeg'):
#         old_file_path = os.path.join(path,filename)
#         new_name = f'photo-{counter}.png'
#         new_file_path = os.path.join(path,new_name)
#         os.rename(old_file_path,new_file_path)
#         counter += 1
#         print(f"{new_name} file name rename") 

# update 
import mysql.connector
from mysql.connector import Error
from ftplib import FTP

def update_image_path(cursor, shop_id, image_file_name):
    try:
        # Update shop details with image file path in the database
        sql_update_query = """UPDATE shops SET photo = %s WHERE shop_id = %s"""
        update_tuple = (image_file_name, shop_id)
        cursor.execute(sql_update_query, update_tuple)
        print(f"Image path {image_file_name} for shop ID {shop_id} updated successfully")
    except Error as error:
        print(f"Failed to update data in MySQL table {error}")

def list_ftp_images(ftp, directory):
    ftp.cwd(directory)
    files = ftp.nlst()
    return [f for f in files if f.endswith(('.jpg', '.jpeg', '.png'))]

def process_images(ftp_host, ftp_user, ftp_password, ftp_directory):
    try:
        # Connect to FTP server
        ftp = FTP(ftp_host)
        ftp.login(ftp_user, ftp_password)
        cursor = mydb.cursor()
        
        image_files = list_ftp_images(ftp, ftp_directory)
        
        for image_file in image_files:
            try:
                # Extract shop ID from filename
                shop_id = int(image_file.split('-')[1].split('.')[0])
                update_image_path(cursor, shop_id, image_file)
            except ValueError:
                print(f"Skipping file {image_file}, unable to extract shop ID")
        
        mydb.commit()
        cursor.close()
        mydb.close()
        ftp.quit()
        print("All updates completed and connections closed successfully")
    except Exception as e:
        print(f"Error processing images: {e}")

# Example usage
ftp_host = '89.117.27.223'
ftp_user = 'u790304855'
ftp_password = 'Badhon12345'
ftp_directory = '/domains/aarambd.com/public_html/photo'  # Update this to your directory

process_images(ftp_host, ftp_user, ftp_password, ftp_directory)
