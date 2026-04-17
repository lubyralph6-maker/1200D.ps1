# แก้ปัญหา TLS สำหรับการดาวน์โหลดไฟล์
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- Configuration ---
$Name = "1200C"
$OwnerId = "pMLzpDhdpz"
$Secret = "cf5b8c684130d59635488970414c11c90f0b09ec18d2d044cefdc345997066a1"
$Version = "1.3"
$BaseUrl = "https://keyauth.win/api/1.2/"

Clear-Host
Write-Host "[*] System Initializing..." -ForegroundColor Cyan

# 1. Init Session
$InitData = @{ type = "init"; ver = $Version; name = $Name; ownerid = $OwnerId }
$InitRes = Invoke-RestMethod -Method Post -Uri $BaseUrl -Body $InitData

if ($InitRes.success -ne $true) {
    Write-Host "[!] Auth Server Connection Failed." -ForegroundColor Red
    return
}

$SessionId = $InitRes.sessionid

# 2. Login Screen
Write-Host ""
$LicenseKey = Read-Host "[+] Enter license key"

$AuthData = @{
    type = "license"
    key = $LicenseKey
    ver = $Version
    name = $Name
    ownerid = $OwnerId
    sessionid = $SessionId
}
$AuthRes = Invoke-RestMethod -Method Post -Uri $BaseUrl -Body $AuthData

if ($AuthRes.success -ne $true) {
    Write-Host "[!] $($AuthRes.message)" -ForegroundColor Red
    return
}

# 3. Get Variables (AOB)
$VarOrig = Invoke-RestMethod -Method Post -Uri $BaseUrl -Body @{ type = "var"; varid = "original_aob"; sessionid = $SessionId; name = $Name; ownerid = $OwnerId }
$VarPatch = Invoke-RestMethod -Method Post -Uri $BaseUrl -Body @{ type = "var"; varid = "patch_value"; sessionid = $SessionId; name = $Name; ownerid = $OwnerId }

Clear-Host
Write-Host "[+] Login Success!" -ForegroundColor Green
Write-Host "--------------------------"
Write-Host "[1] Clean History"
Write-Host "[2] Instant Patch"
$Choice = Read-Host "Select"

if ($Choice -eq "1") {
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    Write-Host "[+] PowerShell History Cleared." -ForegroundColor Green
}
elseif ($Choice -eq "2") {
    Write-Host "[*] Patching FiveM..." -ForegroundColor Yellow
    $OrigHex = $VarOrig.message.Replace(" ","")
    $PatchHex = $VarPatch.message.Replace(" ","")

    # เรียก Python มารับช่วงต่อเพื่อ Patch Memory
    $PyCode = @"
import pymem
try:
    pm = pymem.Pymem('FiveM_GTAProcess.exe')
    addr = pymem.pattern.pattern_scan_all(pm.process_handle, bytes.fromhex('$OrigHex'))
    if not addr: addr = pymem.pattern.pattern_scan_all(pm.process_handle, bytes.fromhex('$PatchHex'))
    if addr:
        pm.write_bytes(addr, bytes.fromhex('$PatchHex'), len(bytes.fromhex('$PatchHex')))
        print('SUCCESS')
    else: print('NOT_FOUND')
except Exception as e: print(e)
"@
    $Res = $PyCode | python -
    if ($Res -match "SUCCESS") { 
        Write-Host "[+] Patch Done! You can play now." -ForegroundColor Green 
    } else { 
        Write-Host "[!] Patch Failed: $Res" -ForegroundColor Red 
    }
}
