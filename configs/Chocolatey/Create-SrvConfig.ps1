$Settings = @{
    Name   = "nexus"
    Server = "http://10.82.24.21:10000/repository/chocolatey-group"
}

$Settings | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\settings.json" -Encoding default