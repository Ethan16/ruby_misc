@echo off

start "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://200.201.136.106/login"
::start "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://200.201.136.106/?m=/mod-console/index&n-hfs&vmid=4996177986762&vmname=win7x86-0010001"

ping -n 10 127.0.0.1>nul

::taskkill /f /im chrome.exe
