import pymem
import os
import time
from colorama import Fore, init

init(autoreset=True)

# ใส่ค่า AOB ของคุณที่นี่ได้เลย (ไม่ต้องดึงจาก KeyAuth)
ORIG_AOB = "ใส่เลข Hex เดิมที่นี่"
PATCH_AOB = "ใส่เลข Hex ที่ต้องการแก้ที่นี่"
TARGET = "FiveM_GTAProcess.exe"

def patch():
    print(f"{Fore.CYAN}[*] Searching for {TARGET}...")
    try:
        pm = pymem.Pymem(TARGET)
        orig = bytes.fromhex(ORIG_AOB.replace(" ", ""))
        patch = bytes.fromhex(PATCH_AOB.replace(" ", ""))
        
        addr = pymem.pattern.pattern_scan_all(pm.process_handle, orig)
        if not addr:
            addr = pymem.pattern.pattern_scan_all(pm.process_handle, patch)
            
        if addr:
            pm.write_bytes(addr, patch, len(patch))
            print(f"{Fore.GREEN}[+] Patch Successfully Applied!")
        else:
            print(f"{Fore.RED}[!] Pattern Not Found!")
    except Exception as e:
        print(f"{Fore.RED}[!] Error: {e}")

if __name__ == "__main__":
    os.system("title FiveM Instant Patcher")
    patch()
    print("\nClosing in 5 seconds...")
    time.sleep(5)
