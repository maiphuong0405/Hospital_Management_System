# ==============================================================================
# PROJECT 02: HOSPITAL MANAGEMENT SYSTEM
# Course: DATCOM Lab
# Developer: Phạm Mai Phương - Khoa học dữ liệu 66A
# ==============================================================================
import mysql.connector
from mysql.connector import Error

class HospitalDB:
    def __init__(self, host, user, password, database):
        self.config = {
            'host': host,
            'user': user,
            'password': password,
            'database': database
        }

    def get_connection(self):
        """Tạo và trả về kết nối đến CSDL."""
        try:
            return mysql.connector.connect(**self.config)
        except Error as e:
            print(f"[LỖI] Không thể kết nối tới MySQL: {e}")
            return None

    def add_patient(self, name, dob, gender, address, phone):
        """Thêm bệnh nhân mới an toàn bằng parameterized query."""
        conn = self.get_connection()
        if not conn: return

        query = """
            INSERT INTO Patients (PatientName, DateOfBirth, Gender, Address, PhoneNumber) 
            VALUES (%s, %s, %s, %s, %s)
        """
        values = (name, dob, gender, address, phone)

        try:
            cursor = conn.cursor()
            cursor.execute(query, values)
            conn.commit()
            print(f"[THÀNH CÔNG] Đã thêm bệnh nhân: {name}")
        except Error as e:
            print(f"[LỖI] Lỗi khi thêm bệnh nhân: {e}")
            conn.rollback()
        finally:
            cursor.close()
            conn.close()

    def search_patient(self, keyword):
        """Tìm kiếm bệnh nhân theo tên."""
        conn = self.get_connection()
        if not conn: return

        query = "SELECT PatientID, PatientName, DateOfBirth, PhoneNumber FROM Patients WHERE PatientName LIKE %s"
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(query, (f"%{keyword}%",))
            results = cursor.fetchall()
            
            if not results:
                print("[THÔNG BÁO] Không tìm thấy bệnh nhân nào.")
                return

            print("\n--- KẾT QUẢ TÌM KIẾM ---")
            for row in results:
                print(f"ID: {row['PatientID']} | Tên: {row['PatientName']} | SĐT: {row['PhoneNumber']}")
            print("------------------------\n")
        except Error as e:
            print(f"[LỖI] Lỗi khi tìm kiếm: {e}")
        finally:
            cursor.close()
            conn.close()

def main_menu():
    # Khởi tạo kết nối (Nhớ thay đổi password thành mật khẩu MySQL của bạn)
    db = HospitalDB(host="localhost", user="root", password="chuthenghia198", database="HospitalManagement")

    while True:
        print("\n=== HỆ THỐNG QUẢN LÝ BỆNH VIỆN ===")
        print("1. Thêm bệnh nhân mới")
        print("2. Tìm kiếm bệnh nhân")
        print("3. Thoát")
        
        choice = input("Chọn chức năng (1-3): ")

        if choice == '1':
            name = input("Tên bệnh nhân: ")
            dob = input("Ngày sinh (YYYY-MM-DD): ")
            gender = input("Giới tính (Male/Female/Other): ")
            address = input("Địa chỉ: ")
            phone = input("Số điện thoại: ")
            db.add_patient(name, dob, gender, address, phone)
            
        elif choice == '2':
            kw = input("Nhập tên bệnh nhân cần tìm: ")
            db.search_patient(kw)
            
        elif choice == '3':
            print("Đang thoát chương trình...")
            break
        else:
            print("[LỖI] Lựa chọn không hợp lệ. Vui lòng thử lại!")

if __name__ == "__main__":
    main_menu()