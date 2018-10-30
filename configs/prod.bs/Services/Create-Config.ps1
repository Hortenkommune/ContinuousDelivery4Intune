$Svcs = @(
    @{
        Name = "W32Time"
        Mode = "Run"
    }
)
$Svcs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default