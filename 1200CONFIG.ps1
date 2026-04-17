# 1. ตั้งค่าเบื้องต้น
$projectName = "1200C"
$Host.UI.RawUI.WindowTitle = "$projectName Loader"
Clear-Host

# 2. ปิดโปรเซสเก่าที่อาจค้างอยู่
Stop-Process -Name "$projectName" -ErrorAction SilentlyContinue

# 3. สร้างสคริปต์ Python ที่จะไปรันบนหน้า CMD (ใส่ Logic ทั้งหมดที่นี่)
$pythonCode = @"
import os
import sys
import time
import requests
import pymem
from colorama import Fore, init

init(autoreset=True)

# --- Configuration ---
APP_NAME = "1200C"
OWNER_ID = "pMLzpDhdpz"
SECRET   = "cf5b8c684130d59635488970414c11c90f0b09ec18d2d044cefdc345997066a1"
VERSION  = "1.3"

os.system(f'title {APP_NAME} - Authentication')

def main():
    print(f"\n {Fore.RED}[+] {Fore.WHITE}Product : {Fore.RED}{APP_NAME} Premium")
    
    # --- หน้าใส่คีย์บน CMD ---
    key = input(f" {Fore.RED}[+] {Fore.WHITE}Enter license key -> {Fore.YELLOW}").strip()
    
    # --- ส่วนการเช็คคีย์ (KeyAuth) ---
    # (ในตัวอย่างนี้ผมใส่ Print จำลองไว้ คุณสามารถใส่ Logic KeyAuth.license(key) ของคุณที่นี่)
    print(f" {Fore.CYAN}[*] Verifying Key...{Fore.WHITE}")
    time.sleep(1.5)
    
    # สมมติว่าผ่าน (คุณต้องไปเชื่อม KeyAuth Logic ตรงนี้)
    print(f" {Fore.GREEN}[+] Login Success!{Fore.WHITE}")
    time.sleep(1)
    
    # --- เมนูรัน Patch ---
    os.system('cls')
    print(f"\n {Fore.RED}{APP_NAME} - Ready to Patch")
    print(f" {Fore.WHITE}[1] Patch FiveM")
    print(f" {Fore.WHITE}[2] Clean History")
    choice = input(f"\n Select -> ")
    
    if choice == "1":
        print(f" {Fore.YELLOW}[*] Searching for FiveM...")
        # ใส่ Logic Pymem.write_bytes ที่นี่
        time.sleep(2)
        print(f" {Fore.GREEN}[+] Done!")
    
    print(f"\nClosing in 5 seconds...")
    time.sleep(5)

if __name__ == '__main__':
    main()
"@

# 4. บันทึกโค้ดลงไฟล์ชั่วคราว
$tempFile = "$env:TEMP\1200C_Task.py"
$pythonCode | Out-File -FilePath $tempFile -Encoding utf8

# 5. สั่งรันขึ้นมาเป็นหน้าต่าง CMD ใหม่ (ไม่รันใน PowerShell นี้)
Write-Host "[*] Initializing $projectName..." -ForegroundColor Cyan
Start-Process "python.exe" -ArgumentList $tempFile -Verb RunAs

# 6. ปิดหน้าต่าง PowerShell ทันที
exit
