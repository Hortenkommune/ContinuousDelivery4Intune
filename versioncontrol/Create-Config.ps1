$Versions = @(
    @{
        Name    = "prod.bs"
        Version = "1.0.0"
    },
    @{
        Name    = "prod.us"
        Version = "1.0.0"
    },
    @{
        Name    = "prod.hovos"
        Version = "1.0.0"
    },
    @{
        Name    = "beta"
        Version = "1.0.2"
    }
)
$Versions | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default