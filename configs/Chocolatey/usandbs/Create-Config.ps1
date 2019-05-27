$Choco = @(
    @{
        Name = "gimp"
        Mode = "install"
    },
    @{
        Name = "audacity"
        Mode = "install"
    }
)

$Choco | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default