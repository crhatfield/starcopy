#############################################
## AUTHOR: CecilTheNerd 
## Version: 2026-03-12
## Buy me a Coffee: https://ko-fi.com/CecilTheNerd
## BUY ME A COFFEE: https://ko-fi.com/CecilTheNerd
## REFERRAL CODE: https://www.robertsspaceindustries.com/enlist?referral=STAR-KSVL-CVC2
############################################

$ConfigFile = "starCopyConfig.txt"
$TestMode = $false  # Toggle this to $false for a cleaner "User" experience

# --- 1. Functions ---
function Add-UpdateSymlink ($AvailablePaths) {
    if (-not $TestMode) { Clear-Host }
    Write-Host "--- Add / Update Symlink ---" -ForegroundColor Yellow

    # --- Step 1: Filter for REAL folders that exist (The Master Files) ---
    [array]$ValidTargets = $AvailablePaths | Where-Object {
        (Test-Path $_) -and (-not (Get-Item $_).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint))
    }

    if ($ValidTargets.Count -eq 0) {
        Write-Host "Error: No real folders found to use as a Target!" -ForegroundColor Red; pause; return
    }

    Write-Host "Step 1: Select the REAL folder (The Master Files)"
    for ($i = 0; $i -lt $ValidTargets.Count; $i++) { Write-Host "$($i + 1). $($ValidTargets[$i])" }
    $tChoice = Read-Host "`nSelect Number"

    # --- Step 2: Filter for non-existent paths OR existing Symlinks ---
    [array]$ValidLinks = $AvailablePaths | Where-Object {
        (-not (Test-Path $_)) -or ((Get-Item $_).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint))
    }

    if ($ValidLinks.Count -eq 0) {
        Write-Host "Error: No available slots for a link (all folders are real)!" -ForegroundColor Red; pause; return
    }

    Write-Host "`nStep 2: Select the location for the LINK (The 'Shortcut')"
    for ($i = 0; $i -lt $ValidLinks.Count; $i++) { Write-Host "$($i + 1). $($ValidLinks[$i])" }
    $lChoice = Read-Host "`nSelect Number"

    # Initialize for [ref]
    $it = 0; $il = 0

    if ([int]::TryParse($tChoice, [ref]$it) -and [int]::TryParse($lChoice, [ref]$il)) {
        if ($it -le $ValidTargets.Count -and $il -le $ValidLinks.Count -and $it -gt 0 -and $il -gt 0) {

            $Target = $ValidTargets[$it - 1]
            $Link   = $ValidLinks[$il - 1]

            if (Test-Path $Link) {
                # Since we filtered, we know this is a ReparsePoint (Symlink)
                Write-Host "Replacing existing link at: $Link" -ForegroundColor Gray
                (Get-Item $Link).Delete()
            }

            try {
                New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
                Write-Host "`nSUCCESS: $Link now points to $Target" -ForegroundColor Green; pause
            } catch {
                Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red; pause
            }
        } else { Write-Host "Invalid Selection."; pause }
    }
}

function Remove-Symlink ($AvailablePaths) {
    if (-not $TestMode) { Clear-Host }
    Write-Host "--- Remove Symlink ---" -ForegroundColor Yellow

    # --- Filter for existing symlinks only ---
    [array]$ExistingLinks = $AvailablePaths | Where-Object {
        (Test-Path $_) -and ((Get-Item $_).Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint))
    }

    if ($ExistingLinks.Count -eq 0) {
        Write-Host "No symlinks found in the config list." -ForegroundColor Red; pause; return
    }

    Write-Host "Select the symlink to REMOVE (the folder it points to will NOT be deleted):"
    for ($i = 0; $i -lt $ExistingLinks.Count; $i++) {
        $target = (Get-Item $ExistingLinks[$i]).Target
        Write-Host "$($i + 1). $($ExistingLinks[$i])" -NoNewline
        Write-Host "  -> $target" -ForegroundColor DarkGray
    }

    $rChoice = Read-Host "`nSelect Number (or B to go Back)"
    if ($rChoice -match '^[Bb]$') { return }

    $ir = 0
    if ([int]::TryParse($rChoice, [ref]$ir) -and $ir -gt 0 -and $ir -le $ExistingLinks.Count) {
        $LinkToRemove = $ExistingLinks[$ir - 1]
        Write-Host "`nThis will remove the symlink at:" -ForegroundColor Yellow
        Write-Host "  $LinkToRemove" -ForegroundColor Cyan
        Write-Host "The real folder it points to will NOT be affected." -ForegroundColor Gray
        $confirm = Read-Host "Confirm removal? (Y/N)"
        if ($confirm -match '^[Yy]$') {
            try {
                (Get-Item $LinkToRemove).Delete()
                Write-Host "`nSUCCESS: Symlink removed." -ForegroundColor Green; pause
            } catch {
                Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red; pause
            }
        } else {
            Write-Host "Cancelled." -ForegroundColor Gray; pause
        }
    } else {
        Write-Host "Invalid Selection." -ForegroundColor Red; pause
    }
}

function Manage-Symlink ($AvailablePaths) {
    while ($true) {
        if (-not $TestMode) { Clear-Host }
        Write-Host "--- Star Citizen Symlink Manager ---" -ForegroundColor Yellow
        Write-Host "1. Add / Update Symlink"
        Write-Host "2. Remove Symlink"
        Write-Host "B. Back"

        $subChoice = Read-Host "`nAction"
        switch ($subChoice) {
            "1" { Add-UpdateSymlink -AvailablePaths $AvailablePaths }
            "2" { Remove-Symlink   -AvailablePaths $AvailablePaths }
            { $_ -match '^[Bb]$' } { return }
            default { Write-Host "Invalid option." -ForegroundColor Red; pause }
        }
    }
}

function Sync-Versions ($Src, $Dst, $Mir = $false) {
    if (-not $TestMode) { Clear-Host }
    
    if (-not (Test-Path $Src)) { Write-Host "[!] Source not found: $Src" -ForegroundColor Red; pause; return }
    if (-not (Test-Path $Dst)) { New-Item -ItemType Directory -Path $Dst -Force | Out-Null }

    $ModeText = if ($Mir) { "CLEAN MIRROR" } else { "DIRTY COPY" }
    
    Write-Host "MODE:    $ModeText" -ForegroundColor Yellow
    Write-Host "FROM:    $Src" -ForegroundColor Cyan
    Write-Host "TO:      $Dst" -ForegroundColor Cyan
    
    $confirm = Read-Host "`nProceed? (Y/N)"
    if ($confirm -notmatch 'y') { return }

    $SyncFlag = if ($Mir) { "/MIR" } else { "/E" }

    if ($TestMode) {
        robocopy "$Src" "$Dst" $SyncFlag /MT:8 /XO /V /R:3 /W:5
    } else {
        Clear-Host
        # Standard loop for the 6-line gap
        for ($i = 0; $i -lt 6; $i++) { Write-Host "" }
        
        Write-Host "--- Syncing Star Citizen ---" -ForegroundColor Yellow
        Write-Host "MODE: $ModeText"
        Write-Host "FROM: $Src"
        Write-Host "TO:   $Dst" -ForegroundColor Cyan
        Write-Host "-------------------------------------------"
        
        $currentFile = "Scanning files..."
        
        # Robocopy flags: /NJH (No Job Header), /NJS (No Job Summary), /NDL (No Directory List)
        robocopy "$Src" "$Dst" $SyncFlag /MT:8 /XO /NJH /NJS /NDL /NC /NS /R:3 /W:5 | ForEach-Object {
            $line = $_.Trim()
            
            if ($line -match '(\d+(\.\d+)?)%') {
                $percent = [float]$matches[1]
                # Update the blue bar with the percent AND the filename
                Write-Progress -Activity "Syncing Files" -Status "[$percent%] Working on: $currentFile" -PercentComplete $percent
            } 
            elseif ($line -ne "" -and $line -notmatch '^\s+\d+\s+') {
                # This captures the new filename
                $currentFile = Split-Path $line -Leaf
                
                # Update the bar immediately for the new file at 0%
                Write-Progress -Activity "Syncing Files" -Status "[0%] Working on: $currentFile" -PercentComplete 0
                
                # OPTIONAL: This prints the filename to the console below your TO: line
                Write-Host "Current: $currentFile                     " -NoNewline
                Write-Host "`r" -NoNewline # Returns cursor to start of line to overwrite for next file
            }
        }
        Write-Progress -Activity "Syncing Files" -Completed
    }
    
    Write-Host "`n`nOperation Complete!" -ForegroundColor Green; pause
}

function Swap-Names ($PathA, $PathB) {
    if (-not $TestMode) { Clear-Host }
    Write-Host "--- Instant Folder Swap ---" -ForegroundColor Yellow
    
    if ($TestMode) { 
        Write-Host "[DEBUG] Path A: $PathA" -ForegroundColor Gray
        Write-Host "[DEBUG] Path B: $PathB" -ForegroundColor Gray
    }

    $confirm = Read-Host "`nSwap these folder names? (Y/N)"
    if ($confirm -match 'y') {
        try {
            $ParentDir = Split-Path $PathA
            $NameA = Split-Path $PathA -Leaf
            $NameB = Split-Path $PathB -Leaf
            $TempName = "CopyVerse_TEMP"

            if ($TestMode) { Write-Host "[DEBUG] Target Temp Name: $TempName" -ForegroundColor Gray }

            Rename-Item -Path $PathA -NewName $TempName -ErrorAction Stop
            Rename-Item -Path $PathB -NewName $NameA -ErrorAction Stop
            Rename-Item -Path (Join-Path $ParentDir $TempName) -NewName $NameB -ErrorAction Stop
            
            Write-Host "Success! Folders swapped." -ForegroundColor Green; pause
        } catch {
            Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
            pause
        }
    }
}

# --- 2. Main Menu Loop ---
while ($true) {
    if (Test-Path $ConfigFile) {
        [array]$AvailablePaths = Get-Content $ConfigFile |
            Where-Object { $_.Trim() -notlike "#*" } |
            ForEach-Object { $_.Split('#')[0].Trim() } |
            Where-Object { $_ -ne "" }
    } else {
        Write-Host "Error: $ConfigFile not found!" -ForegroundColor Red; pause; exit
    }

    if (-not $TestMode) { Clear-Host }
    Write-Host "--- Star Citizen CopyVerse (Dynamic) ---" -ForegroundColor Yellow
    if ($TestMode) { Write-Host "[DEBUG MODE ACTIVE]" -ForegroundColor Magenta }
    Write-Host "1. Dirty Copy (Add/Update)"
    Write-Host "2. Clean Mirror (Wipe & Sync)"
    Write-Host "3. Swap Folder Names (Instant)"
    Write-Host "4. Manage Symbolic Link" # Added Option
    Write-Host "Q. Quit"

    $choice = Read-Host "`nAction"
    if ($choice -eq "q") { return }

    # Changed regex to include 4
    if ($choice -match '^[1-4]$') {
        
        # Choice 4 handles its own dual-selection inside the function
        if ($choice -eq "4") {
            Manage-Symlink -AvailablePaths $AvailablePaths
            continue
        }

        if (-not $TestMode) { Clear-Host }
        Write-Host "--- Select FOLDERS ---" -ForegroundColor Yellow
        for ($i = 0; $i -lt $AvailablePaths.Count; $i++) {
            Write-Host "$($i + 1). $($AvailablePaths[$i])"
        }
        
        $p1 = Read-Host "`nSelect SOURCE folder (Number)"
        $p2 = Read-Host "Select DESTINATION folder (Number)"

        $idx1 = 0; $idx2 = 0 
        if ([int]::TryParse($p1, [ref]$idx1) -and [int]::TryParse($p2, [ref]$idx2)) {
            if ($idx1 -le $AvailablePaths.Count -and $idx2 -le $AvailablePaths.Count -and $idx1 -gt 0 -and $idx2 -gt 0) {
                
                $folderA = $AvailablePaths[$idx1 - 1]
                $folderB = $AvailablePaths[$idx2 - 1]

                if ($folderA -eq $folderB) { 
                    Write-Host "Error: Cannot select the same folder!" -ForegroundColor Red; pause; continue 
                }

                switch ($choice) {
                    "1" { Sync-Versions -Src $folderA -Dst $folderB -Mir $false }
                    "2" { Sync-Versions -Src $folderA -Dst $folderB -Mir $true }
                    "3" { Swap-Names -PathA $folderA -PathB $folderB }
                }
            } else { Write-Host "Selection out of range!"; pause }
        } else { Write-Host "Invalid number!"; pause }
    }
}

