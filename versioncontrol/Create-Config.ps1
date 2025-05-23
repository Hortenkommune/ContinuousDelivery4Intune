﻿$Versions = @(
    @{
        Name    = "prod.bs"
        Version = "1.0.13.7"
    },
    @{
        Name    = "prod.us"
        Version = "1.0.13.7"
    },
    @{
        Name    = "prod.hovos"
        Version = "1.0.13.7"
    },
    @{
        Name    = "prod.bhg"
        Version = "1.0.13.5"
    },
    @{
        Name    = "prod.bakk"
        Version = "1.0.13.7"
    },
    @{
        Name    = "beta"
        Version = "1.0.14.0"
    }
)
$Versions | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default