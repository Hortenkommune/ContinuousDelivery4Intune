$CreateCfgFiles = Get-ChildItem $PSScriptRoot -Recurse | Where-Object { $_.Name -eq "Create-Config.ps1" }

ForEach ($file in $CreateCfgFiles) {
    Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$($file.FullName)`""
}

Start-Sleep -Seconds 10

$CreateScriptFile = "$PSScriptRoot\Install\Create-Scripts.ps1"
Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$CreateScriptFile`"" -Wait