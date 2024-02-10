# Set silent mode
#$ErrorActionPreference = 'silentlycontinue'
#$ProgressPreference = 'SilentlyContinue' 

# Check for elevated privileges and restart the script with elevated privileges if not already elevated
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Skip Line
write-host "`n"

# SoftPCS V1.0
Write-Host "SoftPCS V1.0"

# Skip Line
write-host "`n"

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Clear output
Clear-Host

# Personalization
Write-Host "Ajout des informations OEM..."
Copy-Item "$PSScriptRoot\OEMlogo.bmp" "$env:USERPROFILE\pictures\OEMlogo.bmp" -Force
$regKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation'
$regKeyValues = @{
    'Manufacturer' = 'PC Supreme Inc.'
    'Logo' = "$env:USERPROFILE\pictures\OEMlogo.bmp"
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

# Installation des applications avec Chocolatey
Write-Host "Installation de VLC, Chrome, Adobe Reader et 7-Zip avec Chocolatey..."
$vlcInstalled = choco install vlc -y --force
$chromeInstalled = choco install googlechrome -y --force
$adobeReaderInstalled = choco install adobereader -y --force
$sevenZipInstalled = choco install 7zip -y --force

# Verification de l'installation de chaque application
if ($vlcInstalled -match "has been installed.") {
    Write-Host "VLC installe avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation de VLC." -ForegroundColor Red
}

if ($chromeInstalled -match "has been installed.") {
    Write-Host "Google Chrome installe avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation de Google Chrome." -ForegroundColor Red
}

if ($adobeReaderInstalled -match "has been installed.") {
    Write-Host "Adobe Reader installe avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation d'Adobe Reader." -ForegroundColor Red
}

if ($sevenZipInstalled -match "has been installed.") {
    Write-Host "7-Zip installe avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation de 7-Zip." -ForegroundColor Red
}

# Skip Line
write-host "`n"

# Telechargement et installation de TeamViewer
Write-Host "Telechargement et installation de TeamViewer..."
$teamviewerInstallerUrl = "https://pcsupreme.com/TeamViewer_Host_Setup.exe"
$teamviewerInstallerPath = "$env:TEMP\TeamViewerSetup.exe"
Invoke-WebRequest -Uri $teamviewerInstallerUrl -OutFile $teamviewerInstallerPath
$teamviewerProcess = Start-Process -FilePath $teamviewerInstallerPath -ArgumentList "/S" -PassThru
if ($teamviewerProcess -ne $null -and $teamviewerProcess.WaitForExit()) {
    Write-Host "TeamViewer installe avec succes." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'installation de TeamViewer." -ForegroundColor Red
}

# Skip Line
write-host "`n"
write-host "`n"

# Demande de changement de nom d'ordinateur
$changeName = Read-Host "Voulez-vous changer le nom de l'ordinateur ? (o/n)"
if ($changeName.ToLower() -eq "o") {
    $newName = Read-Host "Entrez le nouveau nom de l'ordinateur"
    Write-Host "Changement du nom de l'ordinateur en cours..."
    Rename-Computer -NewName $newName -Force -Restart
    Write-Host "Changement du nom de l'ordinateur complete !" -ForegroundColor Green
} elseif ($changeName.ToLower() -eq "n") {
    Write-Host "Le nom de l'ordinateur ne sera pas modifie."
} else {
    Write-Host "Entree invalide. Le nom de l'ordinateur ne sera pas modifie."
}

# Skip Line
write-host "`n"
write-host "`n"

# Done
Write-Host -NoNewLine "Appuyer sur n'importe quel touche pour quitter...";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');