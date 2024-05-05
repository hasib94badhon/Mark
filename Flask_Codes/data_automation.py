import pandas as pd
import os
import mysql.connector

# Load data from Excel file

# excel_path = open("O:/Test_Flutter/aarambd/Assorted.xlsx","r")
# path = os.path.dirname(excel_path)
df = pd.read_excel('Assorted.xlsx', sheet_name='Service')

# MySQL database connection
mydb = mysql.connector.connect(
    host="'localhost'",
    user="root",
    password="",
    database="registration"
)

cursor = mydb.cursor()

# SQL query to insert data
sql = "INSERT INTO service (service_id,category, business_name, address, phone, photo_files) VALUES (%s,%s, %s, %s, %s, %s)"

# Loop through the data and insert into the database
for index, row in df.iterrows():
    # Here we're inserting row data. Ensure your Excel columns match the order in the SQL insert statement
    cursor.execute(sql, (row['sevice_id'],row['category'], row['business_name'], row['address'], row['phone'], row['photo_files']))

# Commit changes and close connection
mydb.commit()
cursor.close()
mydb.close()

print("Data successfully inserted into the database.")
