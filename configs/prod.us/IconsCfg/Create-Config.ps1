$Icons = @(
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/teams.ico"
        Path = "C:\Windows\ico\Teams.ico"
        Mode = "Install"
    },
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/Office_portal.ico"
        Path = "C:\Windows\ico\Office_portal.ico"
        Mode = "Install"
    }
)
$Icons | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default