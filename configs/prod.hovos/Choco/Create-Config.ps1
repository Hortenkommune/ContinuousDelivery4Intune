$ChocoPkgs = @(
    @{
        Name = "microsoft-teams.install"
        Mode = "install"
    }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default