#
# Copyright (C) 2025-26 https://github.com/ArKT-7/nabu-uefi-autopatcher
#
# Made for easy UEFI dual boot kernel patching to enable dualbooting on using magnetic cover/case or Volume buttons using a single command, for booting Windows on the Xiaomi Pad 5 (Nabu).
#

# Define URLs and target paths
$driveLetter = (Get-Location).Drive.Name + ":"
$dbkpDir = Join-Path $driveLetter "dbkp-kernel-patcher"
$binsDir = Join-Path $dbkpDir "bin"
$outDir = Join-Path $dbkpDir "out"
$busybox = Join-Path $binsDir "busybox.exe"
$magiskboot = Join-Path $binsDir "magiskboot.exe"
$dbkpcfg = Join-Path $binsDir "DualBoot.Sm8150.cfg"
$shellcode = Join-Path $binsDir "ShellCode.Nabu.bin"
$shellcode2 = Join-Path $binsDir "ShellCode.Nabu2.bin"
$FD_FILE = Join-Path $binsDir "nabu.fd"

$BASE_URL = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main"
$BASE_URL_MAGNETIC = "$BASE_URL/bin/aloha/fd-files/magnetic"
$BASE_URL_VOLBUTTON = "$BASE_URL/bin/aloha/fd-files/vol-button"
$UEFI_ALOHA_SB = "aloha_EFI_SB.fd"
$UEFI_W11_WHITE_SB = "Win11-White_EFI_SB.fd"
$UEFI_W11_GRADIENT_SB = "win11-gradient_EFI_SB.fd"
$UEFI_NYANKO_SENSEI_SB = "Nyanko-Sensei_EFI_SB.fd"
$UEFI_SIRTORIUS_M_SB = "SirTorius-M_EFI_SB.fd"
$UEFI_JADEKUBPOM_SB = "JadeKubPom_EFI_SB.fd"
$UEFI_CAMBODIA_PORL_SB = "Cambodia-porl_EFI_SB.fd"
$UEFI_XIAOMI_SB = "xiaomi_EFI_SB.fd"
$UEFI_MI_WHITE_SB = "MI-White_EFI_SB.fd"
$UEFI_MI_ORANGE_SB = "MI-Orange_EFI_SB.fd"
$UEFI_WINDROID_SB = "WinDroid_EFI_SB.fd"
$UEFI_CHARA_SB = "Chara-Dreemurr_EFI_SB.fd"
$UEFI_STORYSWAP_SB = "Storyswap-Chara_EFI_SB.fd"
$UEFI_YUKARI_SB = "Yakumo-Yukari_EFI_SB.fd"
$UEFI_RALSEI_SB = "Ralsei_EFI_SB.fd"

$is64bit = [Environment]::Is64BitOperatingSystem
if ($is64bit) {
    $TARGET_KP = Join-Path $binsDir "DBKP-x86_64.exe"
} else {
    $TARGET_KP = Join-Path $binsDir "DBKP-i686.exe"
}

function print {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    Write-Host "$Message" -ForegroundColor $Color
}

function log {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}

function lognl {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "`n[$timestamp] $Message" -ForegroundColor $Color
}

function Prompt {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color -NoNewline
    return Read-Host
}

function nl {
    param (
        [int]$n = 1
    )
    for ($i = 0; $i -lt $n; $i++) {
        Write-Host ""
    }
}

foreach ($dir in @($binsDir, $dbkpDir)) {
    if (-not (Test-Path $dir -PathType Container)) {
        print "`n`nCreating directory: $dir" DarkCyan
        try {
			$null = New-Item -Path $dir -ItemType Directory -ErrorAction SilentlyContinue
        } catch {
            print "`n`nError creating directory: $dir`n$($_.Exception.Message)" Red
        }
    }
}

$requiredtools = @{
    "busybox.exe" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/busybox.exe"
    "magiskboot.exe" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/magiskboot.exe"
    "DBKP-x86_64.exe" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/DualBootKernelPatcher-x86_64.exe"
    "DBKP-i686.exe" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/DualBootKernelPatcher-i686.exe"
    "DualBoot.Sm8150.cfg" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/aloha/DualBoot.Sm8150.cfg"
    "ShellCode.Nabu.bin" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/aloha/ShellCode.Nabu.bin"
    "ShellCode.Nabu2.bin" = "https://raw.githubusercontent.com/arkt-7/nabu-uefi-autopatcher/main/bin/aloha/ShellCode.Nabu2.bin"
}

function Show-Progress {
    param (
        [Parameter(Mandatory)]
        [Single]$TotalValue,
        [Parameter(Mandatory)]
        [Single]$CurrentValue,
        [Parameter(Mandatory)]
        [string]$ProgressText,
        [Parameter()]
        [string]$ValueSuffix,
        [Parameter()]
        [int]$BarSize = 40,
        [Parameter()]
        [switch]$Complete
    )
    $percent = $CurrentValue / $TotalValue
    $percentComplete = $percent * 100
    if ($ValueSuffix) {
        $ValueSuffix = " $ValueSuffix"
    }
    if ($psISE) {
        Write-Progress "$ProgressText $CurrentValue$ValueSuffix of $TotalValue$ValueSuffix" -id 0 -percentComplete $percentComplete            
    }
    else {
        $curBarSize = $BarSize * $percent
        $progbar = ""
        $progbar = $progbar.PadRight($curBarSize,[char]9608)
        $progbar = $progbar.PadRight($BarSize,[char]9617)
        
        if (!$Complete.IsPresent) {
            Write-Host -NoNewLine "`r$ProgressText $progbar [ $($CurrentValue.ToString("#.###").PadLeft($TotalValue.ToString("#.###").Length))$ValueSuffix ] $($percentComplete.ToString("##0.00").PadLeft(6)) %"
        }
        else {
            Write-Host -NoNewLine "`r$ProgressText $progbar [ $($TotalValue.ToString("#.###").PadLeft($TotalValue.ToString("#.###").Length))$ValueSuffix ] $($percentComplete.ToString("##0.00").PadLeft(6)) %"                    
        }                
    }   
}

function Download($files, $destinationDir) {
    foreach ($file in $files.Keys) {
        $destinationPath = Join-Path $destinationDir $file
        $url = $files[$file]
        try {
            $storeEAP = $ErrorActionPreference
            $ErrorActionPreference = 'Stop'
            $response = Invoke-WebRequest -Uri $url -Method Head
            [long]$fileSizeBytes = [int]$response.Headers['Content-Length']
            $fileSizeMB = $fileSizeBytes / 1MB
            nl 2
            $request = [System.Net.HttpWebRequest]::Create($url)
            $webResponse = $request.GetResponse()
            $responseStream = $webResponse.GetResponseStream()
            $fileStream = New-Object System.IO.FileStream($destinationPath, [System.IO.FileMode]::Create)
            $buffer = New-Object byte[] 4096
            [long]$totalBytesRead = 0
            [long]$bytesRead = 0
            $finalBarCount = 0
            do {
                $bytesRead = $responseStream.Read($buffer, 0, $buffer.Length)
                $fileStream.Write($buffer, 0, $bytesRead)
                $totalBytesRead += $bytesRead
                if ($fileSizeBytes -ge 1MB) {
                    $currentVal = $totalBytesRead / 1MB
                    $totalVal = $fileSizeMB
                    $suffix = "MB"
                } else {
                    $currentVal = $totalBytesRead / 1KB
                    $totalVal = $fileSizeBytes / 1KB
                    $suffix = "KB"
                }
                if ($fileSizeBytes -gt 0) {
                    Show-Progress -TotalValue $totalVal -CurrentValue $currentVal -ProgressText "Downloading $file" -ValueSuffix $suffix
                }
                if ($totalBytesRead -eq $fileSizeBytes -and $bytesRead -eq 0 -and $finalBarCount -eq 0) {
                    Show-Progress -TotalValue $totalVal -CurrentValue $currentVal -ProgressText "Downloading $file" -ValueSuffix $suffix -Complete
                    $finalBarCount++
                }
            } while ($bytesRead -gt 0)
            $fileStream.Close()
            $responseStream.Close()
            $webResponse.Close()
            $ErrorActionPreference = $storeEAP
            [GC]::Collect()
        }
        catch {
            $ExeptionMsg = $_.Exception.Message
            log "[ERROR] Download breaks with error : $ExeptionMsg" Red
        }
    }
}

function Download_UEFI {
    param (
        [string]$input_file_SB
    )
    if ($DBKP_METHOD -eq 0) {
        $url = "$BASE_URL_MAGNETIC/$input_file_SB"
    } elseif ($DBKP_METHOD -eq 1) {
        & $busybox rm -f "$shellcode"
        & $busybox mv "$shellcode2" "$shellcode"
        $url = "$BASE_URL_VOLBUTTON/$input_file_SB"
    }
    try {
        $storeEAP = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        $response = Invoke-WebRequest -Uri $url -Method Head
        [long]$fileSizeBytes = [int]$response.Headers['Content-Length']
        $fileSizeMB = $fileSizeBytes / 1MB
        nl
        $request = [System.Net.HttpWebRequest]::Create($url)
        $webResponse = $request.GetResponse()
        $responseStream = $webResponse.GetResponseStream()
        $fileStream = [System.IO.File]::Create($FD_FILE)
        $buffer = New-Object byte[] 4096
            [long]$totalBytesRead = 0
            [long]$bytesRead = 0
            $finalBarCount = 0
            do {
                $bytesRead = $responseStream.Read($buffer, 0, $buffer.Length)
                $fileStream.Write($buffer, 0, $bytesRead)
                $totalBytesRead += $bytesRead
                if ($fileSizeBytes -ge 1MB) {
                    $currentVal = $totalBytesRead / 1MB
                    $totalVal = $fileSizeMB
                    $suffix = "MB"
                } else {
                    $currentVal = $totalBytesRead / 1KB
                    $totalVal = $fileSizeBytes / 1KB
                    $suffix = "KB"
                }
                if ($fileSizeBytes -gt 0) {
                    Show-Progress -TotalValue $totalVal -CurrentValue $currentVal -ProgressText "Downloading $file" -ValueSuffix $suffix
                }
                if ($totalBytesRead -eq $fileSizeBytes -and $bytesRead -eq 0 -and $finalBarCount -eq 0) {
                    Show-Progress -TotalValue $totalVal -CurrentValue $currentVal -ProgressText "Downloading $file" -ValueSuffix $suffix -Complete
                    $finalBarCount++
                }
            } while ($bytesRead -gt 0)
            $fileStream.Close()
            $responseStream.Close()
            $webResponse.Close()
            $ErrorActionPreference = $storeEAP
            [GC]::Collect()
        }
        catch {
            $ExeptionMsg = $_.Exception.Message
            log "[ERROR] Download breaks with error : $ExeptionMsg" Red
        }
    }

function Prompt {
    param (
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color -NoNewline
    return Read-Host
}

function Get-ValidBootImage {
    print "`nPlease enter the path to a boot.img file OR a folder containing .img files:`n" Yellow
    $inputPath = Read-Host "Path"
    nl
    $inputPath = $inputPath.Trim('"').Trim()
    if ([string]::IsNullOrWhiteSpace($inputPath)) {
        lognl "[ERROR] No input provided. Exiting..." DarkCyan
        exit
    }
    $minRamdiskBytes = 10MB
    $matchingImgs = @()
    if (Test-Path $inputPath -PathType Container) {
        lognl "[INFO] Searching folder for .img files..." DarkCyan
        $imgFiles = Get-ChildItem -Path $inputPath -Filter *.img -Recurse
    }
    elseif (Test-Path $inputPath -PathType Leaf) {
        if ($inputPath.ToLower().EndsWith(".img")) {
            lognl "[INFO] Single .img file provided. Verifying..." DarkCyan
            $imgFiles = @((Get-Item $inputPath))
        }
        else {
            lognl "[ERROR] File is not a .img file." Red
            return $null
        }
    }
    else {
        lognl "[ERROR] Path does not exist." Red
        return $null
    }
    foreach ($img in $imgFiles) {
        $verifyOutput = & "$magiskboot" verify "$($img.FullName)" 2>&1

        $match = [regex]::Match($verifyOutput, "KERNEL_SZ\s+\[(\d+)\]")
        if ($match.Success) {
            $ramdiskSize = [int]$match.Groups[1].Value
            if ($ramdiskSize -gt $minRamdiskBytes) {
                $matchingImgs += $img.FullName
            }    
        } else {
            lognl "[WARN] KERNEL_SZ not found in $($img.Name)" Red
        }
    }
    if ($matchingImgs.Count -eq 0) {
        lognl "`n[RESULT] No matching .img files found." Red
        return $null
    }
    if ($matchingImgs.Count -eq 1) {
        log "[SUCCESS] One valid image found." Green
        return $matchingImgs[0]
    }
     print "`n[INFO] Multiple matching .img files found:`n" DarkCyan
    for ($i = 0; $i -lt $matchingImgs.Count; $i++) {
        print "$($i + 1)) $($matchingImgs[$i])"
    }
    do {
        nl
        $selection = Prompt "Please enter the number to select an image (1 - $($matchingImgs.Count)): " Yellow
        if ($selection -match '^\d+$') {
            $index = [int]$selection - 1
            if ($index -ge 0 -and $index -lt $matchingImgs.Count) {
                return $matchingImgs[$index]
            }
        }
        print "[ERROR] Invalid selection. Try again." Red
    } while ($true)
}

print "`n`nDual Boot Kernel Patcher for Windows UEFI for Xiaomi Pad 5 (nabu)`n"
print "This script is Written and Made By ArKT, Telegram - '@ArKT_7', Github - 'ArKT-7'"

Download $requiredtools $binsDir
print "`n`n[SUCCESS] Required Tools Download complete.`n" Green

if (Test-Path $outDir) {
    $fileCheck = & $busybox find "$outDir" -mindepth 1 -type f 2>$null
    if (-not $fileCheck) {
        & $busybox rm -rf "$outDir"
        log "[INFO] Existing folder was empty and has been deleted." DarkCyan
    }
    else {
        print "`n[WARNING] Existing files found in $outDir Choose an action:`n" Yellow
        print "1) Delete all existing files from '$outDir' and start fresh"
        print "2) Move old files to a backup folder"
        print "3) Exit script`n"
        do {
            $action = Prompt "Enter your choice (1, 2 or 3): " Yellow

            if ($action -eq "1") {
                & $busybox rm -rf "$outDir"
                print "`n[SUCCESS] Existing folder deleted.`n" Green
                break
            }
            elseif ($action -eq "2") {
                $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
                $folderName = Split-Path -Path $outDir -Leaf
                $backupFolderName = "BACKUP_${timestamp}_$folderName"
                $parentDir = Split-Path -Path $outDir -Parent
                $backupFullPath = Join-Path $parentDir $backupFolderName
                & $busybox mv "$outDir" "$backupFullPath"
                print "`n[SUCCESS] Existing folder backed up as '$backupFolderName'.`n" Green
                break
            }
            elseif ($action -eq "3") {
                lognl "[INFO] Exiting script. No changes made.`n" DarkCyan
                exit 0
            }
            else {
                print "[ERROR] Invalid selection. Please enter a valid number between (1, 2 or 3)`n" Red
            }
        } while ($true)
    }
}

print "`n[WARNING] Please provide the stock boot.img (DO NOT provide a DBKP boot image).`n"

$bootImagePath = Get-ValidBootImage
if ($bootImagePath) {
    lognl "[INFO] Using boot image: $bootImagePath`n" DarkCyan
} else {
    lognl "[ERROR] No valid Android boot image selected. Exiting.`n" Red
    exit 1
}

$dkkp_ask = $false
$DBKP_METHOD = 0
while (-not $dkkp_ask) {
    print "`nChoose Which method you want to use:`n" Cyan
    print " 1. Dualboot using Magnetic case/cover"
    print " 2. Dualboot using Volume buttons"
    print " 3. Exit script`n"
    $dkkp_choice = Prompt "Enter your choice (1, 2 or 3): " Yellow
    switch ($dkkp_choice) {
        "1" {
            print "`nYou selected DualBoot using Magnetic case/cover.`n" Cyan
            $DBKP_METHOD = 0
            print "[INFO] When magnetic case is Closed, Windows will start!" Yellow
            print "[INFO] When magnetic case is Open, Android will start!`n" Yellow
            $dkkp_ask = $true
        }
        "2" {
            print "`nYou selected DualBoot using Volume buttons.`n" Cyan
            $DBKP_METHOD = 1
            print "[INFO] When any button is pressed after MI logo, Windows will start!" Yellow
            print "[INFO] When None of the buttons is pressed, Android will start!`n" Yellow
            $dkkp_ask = $true
        }
        "3" {
            print "Exiting."
            exit
        }
        default {
            print "`nInvalid choice. Please try again.`n" Red
        }
    }
}

$logo_ask = $false
while (-not $logo_ask) {
    print "`nChoose a Boot Logo Option:`n" Cyan
    print " 1. Aloha Inverted V, A Logo"
    print " 2. Windows 11 White Square Logo"
    print " 3. Windows 11 Gradient Rounded Logo"
    print " 4. Nyanko Sensei (Madara) Logo"
    print " 5. SirTorius M Logo"
    print " 6. JadeKubPom Logo"
    print " 7. Cambodia Porl Logo"
    print " 8. Xiaomi Logo"
    print " 9. MI Orange Logo"
    print "10. MI White Logo"
    print "11. WinDroid Logo"
    print "12. Chara Dreemurr Logo"
    print "13. Storyswap Chara Logo"
    print "14. Yakumo Yukari Logo"
    print "15. Ralsei Logo"
    print "16. Exit (btw will add more soon)`n"
    $logo_choice = Prompt "Enter your choice (1 to 16): " Yellow
    switch ($logo_choice) {
        "1" {
            print "`nYou selected Aloha Inverted V, A Logo." Cyan
            Download_UEFI $UEFI_ALOHA_SB
            $logo_ask = $true
        }
        "2" {
            print "`nYou selected Windows 11 White Square Logo." Cyan
            Download_UEFI $UEFI_W11_WHITE_SB
            $logo_ask = $true
        }
        "3" {
            print "`nYou selected Windows 11 Gradient Rounded Logo." Cyan
            download_uefi "$UEFI_W11_GRADIENT_SB"
            $logo_ask = $true
        }
        "4" {
            print "`nYou selected Nyanko Sensei (Madara) Logo." Cyan
            Download_UEFI $UEFI_NYANKO_SENSEI_SB
            $logo_ask = $true
        }
        "5" {
            print "`nYou selected SirTorius M Logo." Cyan
            Download_UEFI $UEFI_SIRTORIUS_M_SB
            $logo_ask = $true
        }
        "6" {
            print "`nYou selected JadeKubPom logo." Cyan
            Download_UEFI $UEFI_JADEKUBPOM_SB
            $logo_ask = $true
        }
        "7" {
            print "`nYou selected Cambodia Porl Logo." Cyan
            Download_UEFI $UEFI_CAMBODIA_PORL_SB
            $logo_ask = $true
        }
        "8" {
            print "`nYou selected Xiaomi Logo." Cyan
            Download_UEFI $UEFI_XIAOMI_SB
            $logo_ask = $true
        }
        "9" {
            print "`nYou selected MI Orange Logo." Cyan
            Download_UEFI $UEFI_MI_ORANGE_SB
            $logo_ask = $true
        }
        "10" {
            print "`nYou selected MI White Logo." Cyan
            Download_UEFI $UEFI_MI_WHITE_SB
            $logo_ask = $true
        }
        "11" {
            print "`nYou selected WinDroid Logo." Cyan
            Download_UEFI $UEFI_WINDROID_SB
            $logo_ask = $true
        }
        "12" {
            print "`nYou selected Chara Dreemurr Logo." Cyan
            Download_UEFI $UEFI_CHARA_SB
            $logo_ask = $true
        }
        "13" {
            print "`nYou selected Storyswap Chara Logo." Cyan
            Download_UEFI $UEFI_STORYSWAP_SB
            $logo_ask = $true
        }
        "14" {
            print "`nYou selected Yakumo Yukari Logo." Cyan
            Download_UEFI $UEFI_YUKARI_SB
            $logo_ask = $true
        }
        "15" {
            print "`nYou selected Ralsei Logo." Cyan
            Download_UEFI $UEFI_RALSEI_SB
            $logo_ask = $true
        }
        "16" {
            print "Exiting." DarkCyan
            exit
        }
        default {
            print "`nInvalid choice. Please try again.`n" Red
        }
    }
}

nl 2
lognl "[INFO] Unpacking boot.img...`n"
$originalDir = Get-Location
if (!(Test-Path $outDir)) {
    & $busybox mkdir -p "$outDir"
}
Set-Location -Path $outDir
& $busybox cp -f "$bootImagePath" "$outDir\stock-boot.img"
& $magiskboot unpack -h "$outDir\stock-boot.img"
if ($LASTEXITCODE -ne 0) {
    Set-Location $originalDir
    lognl "[ERROR] Failed to unpack image!" Red
    exit 1
}
lognl "[SUCCESS] Unpacking completed." Green

lognl "[INFO] Patching kernel...`n"
& $TARGET_KP "$outDir\kernel" "$FD_FILE" "$outDir\patchedKernel" "$dbkpcfg" "$shellcode"
if ($LASTEXITCODE -ne 0) {
    Set-Location $originalDir
    lognl "[ERROR] Kernel patching failed!" Red
    exit 1
}
& $busybox mv "$outDir\patchedKernel" "$outDir\kernel"
lognl "[SUCCESS] Kernel patching completed." Green

lognl "[INFO] Repacking boot.img...`n"
& $magiskboot repack "$outDir\stock-boot.img"
if ($LASTEXITCODE -ne 0) {
    Set-Location $originalDir
    lognl "[ERROR] Failed to repack boot image!" Red
    exit 1
}
& $magiskboot cleanup
lognl "[SUCCESS] Boot.img repacking completed." Green

lognl "[INFO] Copying new patched boot image..." Yellow
& $busybox mv "$outDir\new-boot.img" "$outDir\patched-boot.img"
lognl "[SUCCESS] Patched boot: '$outDir\patched-boot.img'`n" Green

Set-Location $originalDir
print "`n=================================================================" DarkCyan
print "[SUCCESS] Dual Boot Kernel for Windows UEFI patched successfully!" Yellow
print "=================================================================`n" DarkCyan
Remove-Item -Path $binsDir -Recurse -Force
Start-Sleep 1
Start-Process "explorer.exe" "/select,`"$outDir\patched-boot.img`""
exit
