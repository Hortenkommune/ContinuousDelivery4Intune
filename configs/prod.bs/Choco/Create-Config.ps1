$ChocoPkgs = @(
    @{
        Name = "sccmtoolkit"
        Mode = "install"
    },
    @{
        Name = "googlechrome"
        Mode = "install"
    },
    @{
        Name = "audacity"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default