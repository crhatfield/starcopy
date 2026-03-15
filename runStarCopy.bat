::::::::::::::::::::::::::::::::
:: AUTHOR: CecilTheNerd
:: Version: 2026-03-12
:: BUY ME A COFFEE: https://ko-fi.com/CecilTheNerd
:: REFERRAL CODE: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
::
:: DISCLAIMER: This script is provided "as-is" without warranty of any kind, express or implied.
:: The author is not responsible for any data loss, file corruption, game installation issues,
:: or any other damages arising from the use or misuse of this script. Use at your own risk.
:: Always back up your game files before using any third-party tool.
::::::::::::::::::::::::::::::::
@echo off

:: This launches the PowerShell script with the correct permissions
powershell.exe -ExecutionPolicy Bypass -File "%~dp0starCopy.ps1"
if %errorlevel% neq 0 pause
