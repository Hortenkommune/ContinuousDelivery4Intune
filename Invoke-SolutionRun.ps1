$CreateCfgFiles = Get-ChildItem $PSScriptRoot -Recurse | Where-Object { $_.Name -eq "Create-Config.ps1" }

$ProcIDs = $null

ForEach ($file in $CreateCfgFiles) {
    $Proc = Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$($file.FullName)`"" -PassThru
    $ProcIDs += $Proc.Id
}

ForEach ($Proc in $ProcIDs) {
    Wait-Process $Proc
}

$CreateScriptFile = "$PSScriptRoot\Install\Create-Scripts.ps1"
Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$CreateScriptFile`"" -Wait