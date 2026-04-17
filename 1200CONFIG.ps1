# 1. ปิดโปรแกรมที่อาจรันค้างอยู่ (ชื่อโปรเจกต์ 1200C)
Stop-Process -Name "1200C" -ErrorAction SilentlyContinue

# 2. ตั้งค่า Path สำหรับเก็บไฟล์ .exe (เก็บไว้ใน AppData เพื่อความเนียนและเลี่ยง Antivirus บางตัว)
$targetPath = "$env:APPDATA\1200C.exe"

# ลบไฟล์เก่าทิ้งถ้ามีอยู่
if (Test-Path $targetPath) { 
    Remove-Item $targetPath -Force -ErrorAction SilentlyContinue 
}

# 3. ล้าง DNS Cache เพื่อให้ดึงไฟล์ล่าสุดจาก GitHub เสมอ
ipconfig /flushdns | Out-Null

# 4. ตั้งค่า URL ของไฟล์ .exe (ถ้าคุณมีตัว .exe บน GitHub ให้ใส่ลิงก์ตรงนี้)
# แต่ถ้าคุณต้องการให้มันรันเป็น Python Patch ทันที ให้ดูข้อความด้านล่าง
$url = "https://github.com/lubyralph6-maker/1200D.ps1/raw/main/1200C.exe?v=$([guid]::NewGuid())"

# 5. เริ่มกระบวนการดาวน์โหลดและรัน
try {
    Write-Host "[*] Cleaning old files & Downloading latest 1200C..." -ForegroundColor Cyan
    
    # กรณีที่คุณต้องการให้เด้งเป็นหน้า CMD เพื่อ Patch Memory ทันที (ไม่ถามคีย์)
    # ผมแนะนำให้ใช้ Logic สร้างไฟล์ Python ชั่วคราวแบบนี้จะเสถียรที่สุด:
    
    $PythonCode = @"
import pymem
import os
import time
from colorama import Fore, init

init(autoreset=True)
TARGET = 'FiveM_GTAProcess.exe'
ORIG_HEX = '48 89 5C 24 08'  # <--- ใส่ค่าเดิมของคุณที่นี่
PATCH_HEX = '90 90 90 90 90' # <--- ใส่ค่าที่จะแก้ที่นี่

def run():
    os.system('title 1200C INSTANT PATCHER')
    print(f'{Fore.CYAN}[*] Waiting for {TARGET}...')
    try:
        pm = pymem.Pymem(TARGET)
        addr = pymem.pattern.pattern_scan_all(pm.process_handle, bytes.fromhex(ORIG_HEX.replace(" ","")))
        if not addr:
            addr = pymem.pattern.pattern_scan_all(pm.process_handle, bytes.fromhex(PATCH_HEX.replace(" ","")))
            
        if addr:
            pm.write_bytes(addr, bytes.fromhex(PATCH_HEX.replace(" ","")), len(bytes.fromhex(PATCH_HEX.replace(" ",""))))
            print(f'{Fore.GREEN}[+] 1200C Patched Successfully!')
        else:
            print(f'{Fore.RED}[!] Pattern Not Found!')
    except Exception as e:
        print(f'{Fore.RED}[!] Error: {e}')
    
    print('\nClosing in 5 seconds...')
    time.sleep(5)

if __name__ == '__main__':
    run()
"@
    # บันทึกโค้ดเป็นไฟล์ .py
    $pyFile = "$env:TEMP\1200C_Task.py"
    $PythonCode | Out-File -FilePath $pyFile -Encoding utf8

    # 6. รันขึ้นมาเป็นหน้าต่างใหม่ทันที (RunAs Admin)
    Write-Host "[+] Launching 1200C Patcher..." -ForegroundColor Green
    Start-Process "python.exe" -ArgumentList $pyFile -Verb RunAs
    
    # ปิดหน้าต่าง PowerShell เดิมทิ้ง
    exit

} catch {
    Write-Host "Process Failed!" -ForegroundColor Red
    exit
}
