$Svcs = @(
    @{
        Name         = "W32Time"
        DesiredState = "Run"
    }
)
$Svcs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default