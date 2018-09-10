$ChocoPkgs = @(
    @{
        Name = "googlechrome"
        Mode = "install"
    },
    @{
        Name = "gimp"
        Mode = "install"
    },
    @{
        Name = "audacity"
        Mode = "install"
    },
    @{
        Name = "sccmtoolkit"
        Mode = "install"
    },
    @{
        Name = "microsoft-teams.install"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default