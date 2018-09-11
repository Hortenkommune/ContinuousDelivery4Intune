$Versions = @(
    @{
        Name    = "prod.bs"
        Version = "0.0.3"
    },
    @{
        Name    = "prod.us"
        Version = "0.0.3"
    },
    @{
        Name    = "prod.hovos"
        Version = "0.0.3"
    },
    @{
        Name    = "beta"
        Version = "0.0.3"
    }
)
$Versions | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default