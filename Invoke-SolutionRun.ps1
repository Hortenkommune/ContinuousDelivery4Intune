$CreateCfgFiles = Get-ChildItem $PSScriptRoot -Recurse | Where-Object { $_.Name -eq "Create-Config.ps1" }

ForEach ($file in $CreateCfgFiles) {
    Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$($file.FullName)`"" -Wait
}

$CreateScriptFile = "$PSScriptRoot\Install\Create-Scripts.ps1"
Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$CreateScriptFile`"" -Wait