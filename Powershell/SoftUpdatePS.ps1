# SoftUpdatePS V3.1
# Script.ps1
#
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.windowsize
$newsize.height = 8
$newsize.width = 70
$pswindow.windowsize = $newsize

Remove-Item KVRT.exe
Remove-Item RogueKiller64.exe
Remove-Item RogueKiller32.exe
Remove-Item AdwCleaner.exe
cls
Invoke-WebRequest "http://devbuilds.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe" -OutFile KVRT.exe 
Invoke-WebRequest "https://download.adlice.com/api/?action=download&app=roguekiller&type=x64" -OutFile RogueKiller64.exe
Invoke-WebRequest "https://download.adlice.com/api/?action=download&app=roguekiller&type=x86" -OutFile RogueKiller32.exe
Invoke-WebRequest "https://download.toolslib.net/download/direct/1/latest?channel=release" -OutFile AdwCleaner.exe
cls
powercfg -change -monitor-timeout-ac 0
powercfg -x -standby-timeout-ac 0