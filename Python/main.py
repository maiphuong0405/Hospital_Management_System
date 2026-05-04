import patient_management as pm
import doctor_management as dm
import appointment_management as am
import reports as rp

def show_menu():
    print("\n" + "="*40)
    print("HỆ THỐNG QUẢN LÝ BỆNH VIỆN - DATCOM LAB")
    print("="*40)
    print("1. Thêm bệnh nhân mới")
    print("2. Tìm kiếm bệnh nhân")
    print("3. Xem danh sách Bác sĩ")
    print("4. Đặt lịch hẹn khám")
    print("5. Báo cáo: Lịch hẹn trong ngày")
    print("0. Thoát chương trình")
    print("="*40)

def main():
    while True:
        show_menu()
        choice = input("Vui lòng chọn chức năng (0-5): ")
        
        if choice == '1':
            name = input("Tên bệnh nhân: ")
            dob = input("Ngày sinh (YYYY-MM-DD): ")
            gender = input("Giới tính (Male/Female/Other): ")
            address = input("Địa chỉ: ")
            phone = input("Số điện thoại: ")
            pm.add_patient(name, dob, gender, address, phone)
            
        elif choice == '2':
            kw = input("Nhập tên hoặc số điện thoại cần tìm: ")
            pm.search_patient(kw)
            
        elif choice == '3':
            dm.list_all_doctors()
            
        elif choice == '4':
            doc_id = int(input("Nhập ID Bác sĩ: "))
            pat_id = int(input("Nhập ID Bệnh nhân: "))
            date = input("Ngày khám (YYYY-MM-DD): ")
            time = input("Giờ khám (HH:MM:SS): ")
            am.schedule_appointment(doc_id, pat_id, date, time)
            
        elif choice == '5':
            rp.report_daily_appointments()
            
        elif choice == '0':
            print("Đang đóng hệ thống... Tạm biệt!")
            break
        else:
            print("[LỖI] Lựa chọn không hợp lệ!")

if __name__ == "__main__":
    main()