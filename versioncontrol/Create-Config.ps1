$Versions = @(
    @{
        Name    = "prod.bs"
        Version = "0.0.1"
    },
    @{
        Name    = "prod.us"
        Version = "0.0.1"
    },
    @{
        Name    = "prod.hovos"
        Version = "0.0.1"
    },
    @{
        Name    = "beta"
        Version = "0.0.1"
    }
)
$Versions | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default