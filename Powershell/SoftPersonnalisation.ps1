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
Write-Host "4. TeamViewer"

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
        4 { choco install teamviewer -y }
        default { Write-Host "Invalid choice: $choice. Skipping." }
    }
}

# Done
Write-Host -NoNewLine "Appuyer sur n'importe quel touche pour quitter...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');