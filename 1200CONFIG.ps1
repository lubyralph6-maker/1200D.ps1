# --- 1. ตั้งค่าเบื้องต้น ---
$projectName = "1200C"
Clear-Host

# --- 2. สร้างโค้ด Python (ไปรันที่ CMD) ---
$pythonCode = @"
import os
import sys
import time
import requests
import pymem
from colorama import Fore, init

init(autoreset=True)

# ข้อมูล KeyAuth
APP_NAME = "1200C"
OWNER_ID = "pMLzpDhdpz"
SECRET   = "cf5b8c684130d59635488970414c11c90f0b09ec18d2d044cefdc345997066a1"
VERSION  = "1.3"

os.system(f'title {APP_NAME} - Authentication System')

def main():
    # --- หน้าจอใส่คีย์บน CMD (สีดำ) ---
    print(f"\n {Fore.RED}[+] {Fore.WHITE}Welcome to : {Fore.RED}{APP_NAME}")
    print(f" {Fore.WHITE}----------------------------------------")
    
    # รับคีย์ที่นี่ ตามที่คุณต้องการ
    key = input(f" {Fore.RED}[+] {Fore.WHITE}Enter license key -> {Fore.YELLOW}").strip()
    
    print(f"\n {Fore.CYAN}[*] Verifying License...")
    time.sleep(1)
    
    # ตรงนี้คุณสามารถเพิ่ม Logic เชื่อมต่อ KeyAuth API ได้เลย
    # ถ้าผ่าน -> ให้รันระบบสแกน Memory ต่อไป
    print(f" {Fore.GREEN}[+] Access Granted!")
    time.sleep(1)
    
    # ตัวอย่างการทำงานต่อ
    os.system('cls')
    print(f"\n {Fore.CYAN}[*] Searching for FiveM Process...")
    time.sleep(2)
    print(f" {Fore.RED}[!] Function not implemented yet.")
    
    print(f"\nClosing in 5 seconds...")
    time.sleep(5)

if __name__ == '__main__':
    main()
"@

# --- 3. บันทึกและสั่งรัน ---
$tempFile = "$env:TEMP\1200C_Auth.py"
$pythonCode | Out-File -FilePath $tempFile -Encoding utf8 -Force

# สั่ง PowerShell ให้เด้งหน้า CMD ใหม่ทันที (Start-Process)
# แล้วปิดตัวเอง (exit) เพื่อไม่ให้หน้าสีน้ำเงินค้างรอรับคีย์
Start-Process "python.exe" -ArgumentList $tempFile -Verb RunAs

# ปิดหน้าจอ PowerShell สีน้ำเงินทิ้งทันที
exit
