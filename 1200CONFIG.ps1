# 1. สั่งปิดโปรแกรมเดิมก่อน (ป้องกันไฟล์ติด Lock)
Stop-Process -Name "_Loader2" -ErrorAction SilentlyContinue
Stop-Process -Name "1200C" -ErrorAction SilentlyContinue

# 2. กำหนด Path ให้ชัดเจนว่าเป็น _Loader2
$exePath = "$env:APPDATA\1200C.exe"

# 3. ล้าง DNS Cache
ipconfig /flushdns

# 4. ตั้งค่า URL ไปที่ 1200C.exe (เพิ่ม GUID เพื่อบังคับดึงตัวใหม่ล่าสุดจาก GitHub)
$url = "https://github.com/lubyralph6-maker/1200CONFIG.ps1/raw/main/1200C.exe?v=$([guid]::NewGuid())"

# 5. ดาวน์โหลดไฟล์ (ใช้โหมดดาวน์โหลดทับตัวเดิมไปเลย)
try {
    Write-Host "Downloading and starting 1200C..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing
} catch {
    Write-Host "Error: Cannot download 1200C from GitHub!" -ForegroundColor Red
    exit
}

# 6. รัน 1200C ขึ้นมาทันที
if (Test-Path $exePath) {
    Write-Host "Launching 1200C..." -ForegroundColor Green
    Start-Process -FilePath $exePath -Verb RunAs
}
