$ScriptsToCreate = Get-Content "$PSScriptRoot\..\versioncontrol\config.json" | ConvertFrom-Json
$InstallScript = Get-Content "$PSScriptRoot\Install-CDforIntune\Install-CDforIntune.ps1"
$Script = Get-Content "$PSScriptRoot\CDforIntuneScript\Script.ps1"

foreach ($i in $ScriptsToCreate) {
    $newInstallScript = $InstallScript.Replace("`$BranchName = `"`"", "`$BranchName = `"$($i.Name)`"")
    $newInstallScript | Out-File "$PSScriptRoot\Install-CDforIntune\Install-CDforIntune.$($i.Name).ps1" -Encoding utf8

    $newScript = $Script.Replace("`$BranchName = `"`"", "`$BranchName = `"$($i.Name)`"")
    $newScript = $newScript.Replace("`$Version = `"`"", "`$Version = `"$($i.Version)`"")
    $newScript | Out-File "$PSScriptRoot\CDforIntuneScript\Script.$($i.Name).ps1" -Encoding utf8
}