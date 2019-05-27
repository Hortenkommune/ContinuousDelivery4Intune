$Settings = @{
    Name   = "hrtcloudchoco"
    Server = "10.85.207.9"
}

$Settings | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\settings.json" -Encoding default