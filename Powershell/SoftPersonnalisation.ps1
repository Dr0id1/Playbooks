# SoftPersonnalisation V1.0
Write-Host "SoftPersonnalisation V1.0"

# Skip Line
write-host "`n"

# Set silent mode
$ErrorActionPreference = 'silentlycontinue'
$ProgressPreference = 'SilentlyContinue' 

# Check for elevated privileges and restart the script with elevated privileges if not already elevated
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Start-Sleep -Seconds 3
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Clear output
Clear-Host

# Display program choices
Write-Host "Select programs to install (type 'all' for all programs):"
Write-Host "1. VLC"
Write-Host "2. Adobe Reader"
Write-Host "3. OpenOffice"
Write-Host "4. 7zip"

# Prompt user to enter program numbers separated by commas or 'all'
$choices = Read-Host "Enter the numbers of the programs you want to install (comma-separated) or type 'all' for all programs"

# Convert the input into an array of choices
$choicesArray = $choices -split ',' | ForEach-Object { $_.Trim() }

# Install the chosen programs using Chocolatey
foreach ($choice in $choicesArray) {
    switch ($choice) {
        'all' {
            choco install vlc adobereader openoffice teamviewer -y
            break
        }
        1 { choco install vlc -y }
        2 { choco install adobereader -y }
        3 { choco install openoffice -y }
        4 { choco install 7zip -y }
        default { Write-Host "Invalid choice: $choice. Skipping." }
    }
}

# Copy wallpaper1.bmp to user's pictures folder
Write-Host "Copie du wallpaper sur le système..."
Copy-Item "$PWD\wallpaper1.bmp" "$env:USERPROFILE\pictures\wallpaper1.bmp" -Force
Write-Host "Done." -f Green

# Skip Line
write-host "`n"

# Set wallpaper path in registry
Write-Host "Modification du wallpaper dans le registre..."
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper -Value "$env:USERPROFILE\pictures\wallpaper1.bmp"
Write-Host "Done." -f Green

# Skip Line
write-host "`n"

# Set wallpaper style in registry
Write-Host "Modification du style du wallpaper dans le registre..."
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallpaperStyle -Value 2
Write-Host "Done." -f Green

# Skip Line
write-host "`n"

# Set tile wallpaper option in registry
Write-Host "Modification de l'option wallpaper dans le registre..."
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name TileWallpaper -Value 0
Write-Host "Done." -f Green

# Skip Line
write-host "`n"

# Personalization
Write-Host "Ajout des informations de PC Suprême dans Info Système..."
Copy-Item "$PWD\OEMlogo.bmp" "$env:LOCALAPPDATA\Microsoft\OEMlogo.bmp" -Force
Copy-Item "$PWD\oeminfo_win10.reg" "$env:LOCALAPPDATA\Microsoft\oeminfo_win10.reg" -Force
Start-Process regedit.exe -ArgumentList "/s $env:LOCALAPPDATA\Microsoft\oeminfo_win10.reg" -Wait
Remove-Item "$env:LOCALAPPDATA\Microsoft\oeminfo_win10.reg" -Force

# Modify additional registry key
$regKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation'
$regKeyValues = @{
    'Manufacturer' = 'PC Suprême Inc.'
    'Logo' = "$env:USERPROFILE\Local Settings\Application Data\Microsoft\OEMlogo.bmp"
    'SupportPhone' = '514-644-1331 // 1-877-301-4809'
    'SupportHours' = 'Lundi au mercredi : 9h30-17h30. Jeudi et Vendredi : 9h30-21h'
}

New-Item -Path $regKeyPath -Force
foreach ($entry in $regKeyValues.GetEnumerator()) {
    Set-ItemProperty -Path $regKeyPath -Name $entry.Key -Value $entry.Value
}
Write-Host "Done." -f Green

# Skip Line
write-host "`n"

# Refresh the desktop
Write-Host "Rafraichissement du bureau..."
[Microsoft.Win32.SystemEvents]::UserPreferenceChanged.Invoke($null, [Microsoft.Win32.UserPreferenceChangedEventArgs]::Desktop)
Write-Host "Done." -f Green

# Wait for the desktop to finish refreshing
Start-Sleep -Seconds 2

# Skip Line
write-host "`n"

# Done
Write-Host -NoNewLine "Appuyer sur n'importe quel touche pour quitter...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');