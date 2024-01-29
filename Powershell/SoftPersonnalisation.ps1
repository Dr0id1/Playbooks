# SoftPersonnalisation V1.2
Write-Host "SoftPersonnalisation V1.2"

# Skip Line
write-host "`n"

# Set silent mode
$ErrorActionPreference = 'silentlycontinue'
#$ProgressPreference = 'SilentlyContinue' 

# Check for elevated privileges and restart the script with elevated privileges if not already elevated
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Ce script doit etre executer en tant qu'administrateur. Redemarrage en cours ..."
    Start-Sleep -Seconds 3
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Clear output
Clear-Host

# Copy wallpaper1.bmp to user's pictures folder
Write-Host "Copie du wallpaper sur le systeme..."
Copy-Item "$PSScriptRoot\wallpaper1.bmp" "$env:USERPROFILE\pictures\wallpaper1.bmp" -Force
Write-Host "Done." -f Green

# Spécifiez le chemin complet de l'image que vous souhaitez utiliser comme fond d'écran
$ImagePath = "$env:USERPROFILE\pictures\wallpaper1.bmp"

# Définir le type du fond d'écran (1 pour l'écran principal, 2 pour l'écran secondaire)
$WallpaperType = 1

# Utiliser la commande SystemParametersInfo pour changer le fond d'écran
# 20 est le code pour SPI_SETDESKWALLPAPER
# Le dernier paramètre de la commande spécifie le type de fond d'écran
# Notez que cela peut nécessiter des privilèges élevés (exécutez PowerShell en tant qu'administrateur)
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

# Appliquer le fond d'écran
[Wallpaper]::SystemParametersInfo(20, 0, $ImagePath, $WallpaperType)


# Skip Line
write-host "`n"

# Personalization
$regKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation'
$regKeyValues = @{
    'Manufacturer' = 'PC Supreme Inc.'
    'Logo' = "$env:USERPROFILE\Local Settings\Application Data\Microsoft\OEMlogo.bmp"
    'SupportPhone' = '514-644-1331 // 1-877-301-4809'
    'SupportHours' = 'Lundi au mercredi : 9h30-17h30. Jeudi et Vendredi : 9h30-21h'
}

New-Item -Path $regKeyPath -Force
foreach ($entry in $regKeyValues.GetEnumerator()) {
    Set-ItemProperty -Path $regKeyPath -Name $entry.Key -Value $entry.Value
}
Write-Host "Done." -f Green

# Wait for the desktop to finish refreshing
Start-Sleep -Seconds 2

# Skip Line
write-host "`n"

# Display program choices
Write-Host "Selectionnez les programmes a installer (tapez 'all' pour tous les programmes) :"
Write-Host "1. VLC"
Write-Host "2. Adobe Reader"
Write-Host "3. OpenOffice"
Write-Host "4. 7zip"
Write-Host "5. Zoom"

# Prompt user to enter program numbers separated by commas or 'all'
$choices = Read-Host "Entrez les numeros des programmes que vous souhaitez installer (separes par des virgules) ou tapez 'all' pour tous les programmes."

# Convert the input into an array of choices
$choicesArray = $choices -split ',' | ForEach-Object { $_.Trim() }

# Install the chosen programs using Chocolatey
foreach ($choice in $choicesArray) {
    switch ($choice) {
        'all' {
            choco install vlc adobereader openoffice 7zip Zoom -y
            break
        }
        1 { choco install vlc -y }
        2 { choco install adobereader -y }
        3 { choco install openoffice -y }
        4 { choco install 7zip -y }
        4 { choco install zoom -y }
        default { Write-Host "Choix invalide: $choice. Skipping." }
    }
}

# Skip Line
write-host "`n"
write-host "`n"

# Done
Write-Host -NoNewLine "Appuyer sur n'importe quel touche pour quitter...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');