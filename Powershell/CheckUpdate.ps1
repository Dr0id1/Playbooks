# Spécifiez les noms des scripts existants et les liens des nouvelles versions
$nomScriptUpdate = "SoftUpdatePS.ps1"
$lienNouvelleVersionUpdate = "https://raw.githubusercontent.com/Dr0id1/Playbooks/master/Powershell/SoftUpdatePS.ps1"

$nomScriptPersonnalisation = "SoftPersonnalisation.ps1"
$lienNouvelleVersionPersonnalisation = "https://raw.githubusercontent.com/Dr0id1/Playbooks/master/Powershell/SoftPersonnalisation.ps1"

# Fonction pour télécharger et mettre à jour un script
function TelechargerEtMettreAJourScript($nomScript, $lienNouvelleVersion) {
    if ((Invoke-WebRequest -Uri $lienNouvelleVersion).Content -ne (Get-Content -Path $nomScript)) {
        Invoke-WebRequest -Uri $lienNouvelleVersion -OutFile $nomScript
        Write-Host "Nouvelle version de $nomScript telechargee avec succes."
        write-host "`n"
    } else {
        Write-Host "Aucune nouvelle version de $nomScript disponible."
    }
}

# Téléchargez et mettez à jour le premier script
TelechargerEtMettreAJourScript $nomScriptUpdate $lienNouvelleVersionUpdate

# Téléchargez et mettez à jour le deuxième script
TelechargerEtMettreAJourScript $nomScriptPersonnalisation $lienNouvelleVersionPersonnalisation