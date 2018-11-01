$CreateCfgFiles = Get-ChildItem "$PSScriptRoot\configs\beta" -Recurse | Where-Object { $_.Name -eq "Create-Config.ps1" }
$CreateCfgFiles += Get-Item "$PSScriptRoot\versioncontrol\Create-Config.ps1"
$Script = Get-Content "$PSScriptRoot\Install\CDforIntuneScript\Script.ps1"

ForEach ($file in $CreateCfgFiles) {
    Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$($file.FullName)`""
}

Start-Sleep -Seconds 10

$BetaScript = Get-Content "$PSScriptRoot\versioncontrol\config.json" | ConvertFrom-Json
#$BetaScript = Get-Content "C:\Users\jonfor\Documents\GitHub\ContinuousDelivery4Intune\versioncontrol\config.json" | ConvertFrom-Json
$BetaScript = $BetaScript | Where-Object { $_.Name -eq "beta" }

$newScript = $Script.Replace("`$BranchName = `"`"", "`$BranchName = `"$($BetaScript.Name)`"")
$newScript = $newScript.Replace("`$Version = `"`"", "`$Version = `"$($BetaScript.Version)`"")
$newScript | Out-File "$PSScriptRoot\Install\CDforIntuneScript\Script.$($BetaScript.Name).ps1" -Encoding utf8