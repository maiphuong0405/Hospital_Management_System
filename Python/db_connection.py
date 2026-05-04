import mysql.connector
from mysql.connector import Error

def get_connection():
    """Tạo và trả về kết nối đến cơ sở dữ liệu HospitalManagementDB."""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='HospitalManagementDB',
            user='root',
            password='chuthenghia198' 
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"[LỖI KẾT NỐI] Không thể kết nối tới MySQL: {e}")
    return None