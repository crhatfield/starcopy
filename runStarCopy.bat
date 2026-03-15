::::::::::::::::::::::::::::::::
:: AUTHOR: CecilTheNerd 
:: Version: 2026-03-12
:: BUY ME A COFFEE: https://ko-fi.com/CecilTheNerd
:: REFERRAL CODE: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
::::::::::::::::::::::::::::::::
@echo off

:: This launches the PowerShell script with the correct permissions
powershell.exe -ExecutionPolicy Bypass -File "%~dp0starCopy.ps1"
if %errorlevel% neq 0 pause
