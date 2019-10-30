$ChocoPkgs = @(
    @{
        Name = "arduino"
        Mode = "install"
    },
    @{
        Name = "googlechrome"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default