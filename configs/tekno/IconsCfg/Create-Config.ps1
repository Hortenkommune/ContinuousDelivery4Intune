$Icons = $null
$Icons | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default