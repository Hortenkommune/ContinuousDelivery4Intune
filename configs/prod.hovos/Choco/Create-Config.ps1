$ChocoPkgs = @(
    @{
        Name = "sccmtoolkit"
        Mode = "install"
    },
    @{
        Name = "microsoft-teams.install"
        Mode = "install"
    },
    @{
        Name = "dotnet3.5"
        Mode = "install"
    },
    @{
        Name = "dotnet"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default