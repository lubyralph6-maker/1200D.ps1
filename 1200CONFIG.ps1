# --- 1. ตั้งค่าหน้าต่าง ---
$Host.UI.RawUI.WindowTitle = "1200C - Memory Patcher"
Clear-Host

# --- 2. ตั้งค่าข้อมูล KeyAuth ---
$Name = "1200C"
$OwnerId = "pMLzpDhdpz"
$Secret = "cf5b8c684130d59635488970414c11c90f0b09ec18d2d044cefdc345997066a1"
$Version = "1.3"
$BaseUrl = "https://keyauth.win/api/1.2/"

# --- 3. ฟังก์ชันเชื่อมต่อ API ---
function Invoke-KeyAuth {
    param($Data)
    try {
        $Response = Invoke-RestMethod -Method Post -Uri $BaseUrl -Body $Data
        return $Response
    } catch {
        return $null
    }
}

# --- 4. เริ่มต้นระบบ (Init) ---
Write-Host "[*] Connecting to Server..." -ForegroundColor Cyan
$InitData = @{ type = "init"; ver = $Version; name = $Name; ownerid = $OwnerId }
$InitRes = Invoke-KeyAuth $InitData

if (-not $InitRes.success) {
    [System.Windows.Forms.MessageBox]::Show("Connection Failed!", "Error")
    exit
}

$SessionId = $InitRes.sessionid

# --- 5. หน้าจอรับ Key ---
Clear-Host
$LicenseKey = Read-Host "[+] Enter license key"

$UserData = @{
    type = "license"
    key = $LicenseKey
    ver = $Version
    name = $Name
    ownerid = $OwnerId
    sessionid = $SessionId
}
$AuthRes = Invoke-KeyAuth $UserData

if (-not $AuthRes.success) {
    Write-Host "[!] $($AuthRes.message)" -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

# --- 6. ดึงค่าตัวแปร (AOB) ---
$VarDataOrig = @{ type = "var"; varid = "original_aob"; sessionid = $SessionId; name = $Name; ownerid = $OwnerId }
$VarDataPatch = @{ type = "var"; varid = "patch_value"; sessionid = $SessionId; name = $Name; ownerid = $OwnerId }

$OrigAOB = (Invoke-KeyAuth $VarDataOrig).message
$PatchValue = (Invoke-KeyAuth $VarDataPatch).message

# --- 7. เมนูเลือกโหมด ---
Clear-Host
Write-Host "[+] Access Granted!" -ForegroundColor Green
Write-Host "[1] Clean History"
Write-Host "[2] Patch Game (Requires Python/Pymem)"
$Choice = Read-Host "Select"

if ($Choice -eq "1") {
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    Write-Host "[+] History Cleaned!" -ForegroundColor Green
}
elseif ($Choice -eq "2") {
    # เนื่องจาก PowerShell แก้ไข Memory โดยตรงได้ยาก 
    # วิธีที่ดีที่สุดคือใช้ PowerShell สั่งให้ Python รันโค้ดสั้นๆ เพื่อ Patch
    $PythonCode = @"
import pymem
import sys
try:
    pm = pymem.Pymem('FiveM_GTAProcess.exe')
    orig = bytes.fromhex('$($OrigAOB.Replace(" ",""))')
    patch = bytes.fromhex('$($PatchValue.Replace(" ",""))')
    addr = pymem.pattern.pattern_scan_all(pm.process_handle, orig)
    if not addr: addr = pymem.pattern.pattern_scan_all(pm.process_handle, patch)
    if addr:
        pm.write_bytes(addr, patch, len(patch))
        print('SUCCESS')
    else:
        print('NOT_FOUND')
except Exception as e:
    print(e)
"@
    $PythonCode | python -
}
