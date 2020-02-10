$Versions = @(
    @{
        Name    = "prod.bs"
        Version = "1.0.11"
    },
    @{
        Name    = "prod.us"
        Version = "1.0.11"
    },
    @{
        Name    = "prod.hovos"
        Version = "1.0.11"
    },
    @{
        Name    = "prod.bhg"
        Version = "1.0.11"
    },
    @{
        Name    = "prod.bakk"
        Version = "1.0.11"
    },
    @{
        Name    = "beta"
        Version = "1.0.12"
    },
    @{
        Name    = "tekno"
        Version = "1.0.11"
    }
)
$Versions | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default