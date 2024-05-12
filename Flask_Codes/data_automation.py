import pandas as pd
import os
import mysql.connector
import openpyxl

from openpyxl_image_loader import SheetImageLoader
# path = os.path.dirname(excel_path)
df = pd.read_excel('Assorted.xlsx', sheet_name='Service')

# MySQL database connection
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="registration"
)

cursor = mydb.cursor()
for filename in os.listdir('downloaded_images'):
        if filename.endswith(".png"):  # Check if the file is a JPEG image
            user_id = filename.split('_')[1].split('.')[0]  # Extract user_id from filename (e.g., '1' from 'image_1.jpg')
            filepath = os.path.join('downloaded_images', filename)
            
            if int(user_id) < 11:
                with open(filepath, 'rb') as file:
                    binary_data = file.read()
            
            # SQL Query to update the image data in the service table where user_id matches
            query = "UPDATE service SET photo = %s WHERE service_id = %s"
            
            # Execute the query
            cursor.execute(query, (binary_data, user_id))
            print(f"Image {filename} updated in the database for user_id {user_id}.")
        else:
             break

       
            # Open the image file and read it into a binary variable
            



# # SQL query to insert data
# sql = "INSERT INTO service (service_id,category, business_name, address, phone, photo_files) VALUES (%s,%s, %s, %s, %s, %s)"

# # Loop through the data and insert into the database
# for index, row in df.iterrows():
#     # Here we're inserting row data. Ensure your Excel columns match the order in the SQL insert statement
#     cursor.execute(sql, (row['sevice_id'],row['category'], row['business_name'], row['address'], row['phone'], row['photo_files']))

# Commit changes and close connection
mydb.commit()
cursor.close()
mydb.close()

print("Data successfully inserted into the database.")
