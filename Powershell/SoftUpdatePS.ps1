# SoftUpdatePS V3.1
# Script.ps1
#
$ErrorActionPreference = 'silentlycontinue'
$ProgressPreference = 'SilentlyContinue' 

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.windowsize
$newsize.height = 8
$newsize.width = 70
$pswindow.windowsize = $newsize

# KVRT
If (Test-Path -path .\KVRT.exe -PathType Leaf) {
    Write-Host "Le fichier KVRT.exe existe."
    Remove-Item Remove-Item KVRT.exe
    Write-Host "Suppression du fichier ..." -f Red
} Else {
    Write-Host "KVRT.exe n'est pas present"  -f Yellow
}

Write-Host "Telechargement de KVRT ..."
Invoke-WebRequest "http://devbuilds.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe" -OutFile KVRT.exe 
if($?)
{
    Write-Host "La nouvelle version de KVRT a ete telecharge" -f Green
}
else {
    Write-Host "Impossible de telecharger KVRT" -f Red
}

# Skip Line
write-host "`n"

# RogueKiller
If (Test-Path -path .\RogueKiller64.exe -PathType Leaf) {
    Write-Host "Le fichier RogueKiller64.exe existe."
    Remove-Item RogueKiller64.exe
    Write-Host "Suppression du fichier ..." -f Red
} Else {
    Write-Host "RogueKiller64.exe n'est pas present"  -f Yellow
}

Write-Host "Telechargement de RogueKiller64 ..."

Invoke-WebRequest "https://download.adlice.com/api/?action=download&app=roguekiller&type=x64" -OutFile RogueKiller64.exe
if($?)
{
    Write-Host "La nouvelle version de RogueKiller a ete telecharge" -f Green
}
else {
    Write-Host "Impossible de telecharger RogueKiller" -f Red
}

# Skip Line
write-host "`n"

# RogueKiller 32bits
If (Test-Path -path .\RogueKiller32.exe -PathType Leaf) {
    Write-Host "Le fichier RogueKiller32.exe existe."
    Remove-Item RogueKiller32.exe
    Write-Host "Suppression du fichier ..." -f Red
} Else {
    Write-Host "RogueKiller32.exe n'est pas present"  -f Yellow
}

Write-Host "Telechargement de RogueKiller32 ..."

Invoke-WebRequest "https://download.adlice.com/api/?action=download&app=roguekiller&type=x86" -OutFile RogueKiller32.exe
if($?)
{
    Write-Host "La nouvelle version de RogueKiller a ete telecharge" -f Green
}
else {
    Write-Host "Impossible de telecharger RogueKiller" -f Red
}

# Skip Line
write-host "`n"

# AdwCleaner
If (Test-Path -path .\AdwCleaner.exe -PathType Leaf) {
    Write-Host "Le fichier AdwCleaner.exe existe."
    Remove-Item AdwCleaner.exe
    Write-Host "Suppression du fichier ..." -f Red
} Else {
    Write-Host "AdwCleaner.exe n'est pas present"  -f Yellow
}

Write-Host "Telechargement de AdwCleaner ..."
Invoke-WebRequest "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release" -OutFile AdwCleaner.exe
if($?)
{
    Write-Host "La nouvelle version de AdwCleaner a ete telecharge" -f Green
}
else {
    Write-Host "Impossible de telecharger AdwCleaner" -f Red
}

# Skip Line
write-host "`n"

# Screensaver
powercfg -change -monitor-timeout-ac 0
powercfg -x -standby-timeout-ac 0


Write-Host -NoNewLine 'Press any key to quit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');