$ChocoPkgs = @(
    @{
        Name = "arduino"
        Mode = "install"
    },
    @{
        Name = "googlechrome"
        Mode = "install"
    }
    @{
        Name = "python"
        Mode = "Install"
    },
    @{
        Name = "processing"
        Mode = "Install"
    },
    @{
        Name = "pycharm_edu"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default