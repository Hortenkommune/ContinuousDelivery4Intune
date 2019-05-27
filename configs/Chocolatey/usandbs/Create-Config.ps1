$Choco = @(
    @{
        Application = "gimp"
        Mode        = "install"
    },
    @{
        Application = "audacity"
        Mode        = "install"
    }
)

$Choco | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default