from db_connection import get_connection

def add_patient(name, dob, gender, address, phone):
    conn = get_connection()
    if not conn: return
    
    try:
        cursor = conn.cursor()
        query = """
            INSERT INTO Patients (PatientName, DateOfBirth, Gender, Address, PhoneNumber) 
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (name, dob, gender, address, phone))
        conn.commit()
        print(f"[THÀNH CÔNG] Đã thêm bệnh nhân: {name}")
    except Exception as e:
        print(f"[LỖI] {e}")
    finally:
        cursor.close()
        conn.close()

def search_patient(keyword):
    conn = get_connection()
    if not conn: return
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = "SELECT * FROM Patients WHERE PatientName LIKE %s OR PhoneNumber LIKE %s"
        cursor.execute(query, (f"%{keyword}%", f"%{keyword}%"))
        results = cursor.fetchall()
        
        if not results:
            print("[THÔNG BÁO] Không tìm thấy bệnh nhân nào.")
        else:
            print("\n--- KẾT QUẢ TÌM KIẾM ---")
            for row in results:
                print(f"ID: {row['PatientID']} | Tên: {row['PatientName']} | SĐT: {row['PhoneNumber']} | DOB: {row['DateOfBirth']}")
    except Exception as e:
        print(f"[LỖI] {e}")
    finally:
        cursor.close()
        conn.close()