$CustomExec = $null
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default