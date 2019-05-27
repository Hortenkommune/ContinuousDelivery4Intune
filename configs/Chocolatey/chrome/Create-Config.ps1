$Choco = @(
    @{
        Application = "googlechrome"
        Mode        = "install"
    }
)

$Choco | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default