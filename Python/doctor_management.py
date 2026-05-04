from db_connection import get_connection

def list_all_doctors():
    conn = get_connection()
    if not conn: return
    
    try:
        cursor = conn.cursor(dictionary=True)
        query = """
            SELECT d.DoctorID, d.DoctorName, d.Specialty, dep.DepartmentName 
            FROM Doctors d
            JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
        """
        cursor.execute(query)
        doctors = cursor.fetchall()
        
        print("\n--- DANH SÁCH BÁC SĨ ---")
        for doc in doctors:
            print(f"ID: {doc['DoctorID']} | BS. {doc['DoctorName']} | Khoa: {doc['DepartmentName']} ({doc['Specialty']})")
    except Exception as e:
        print(f"[LỖI] {e}")
    finally:
        cursor.close()
        conn.close()