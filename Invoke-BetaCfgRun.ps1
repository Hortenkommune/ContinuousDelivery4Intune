$CreateCfgFiles = Get-ChildItem "$PSScriptRoot\configs\beta" -Recurse | Where-Object { $_.Name -eq "Create-Config.ps1" }

ForEach ($file in $CreateCfgFiles) {
    $Proc = Start-Process "powershell.exe" -ArgumentList "-Executionpolicy Bypass -File `"$($file.FullName)`"" -PassThru
    $ProcIDs += $Proc.Id
}