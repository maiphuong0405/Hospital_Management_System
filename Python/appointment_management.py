from db_connection import get_connection

def schedule_appointment(doctor_id, patient_id, appt_date, appt_time):
    conn = get_connection()
    if not conn: return
    
    try:
        cursor = conn.cursor()
        # Gọi Stored Procedure sp_ScheduleAppointment
        # Tham số OUT p_Message được MySQL xử lý tự động trong biến @msg
        cursor.callproc('sp_ScheduleAppointment', (doctor_id, patient_id, appt_date, appt_time, '@msg'))
        
        # Truy xuất biến OUT để lấy thông báo trả về
        cursor.execute("SELECT @_sp_ScheduleAppointment_4")
        result = cursor.fetchone()
        print(f"\n[HỆ THỐNG] {result[0]}")
        
        conn.commit()
    except Exception as e:
        print(f"[LỖI] {e}")
    finally:
        cursor.close()
        conn.close()