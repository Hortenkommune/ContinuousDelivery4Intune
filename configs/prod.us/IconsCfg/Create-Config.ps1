$Icons = @(
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/teams.ico"
        Name = "Teams.ico"
        Mode = "Install"
    },
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/Office_portal.ico"
        Name = "Office_portal.ico"
        Mode = "Install"
    },
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/google_earth.ico"
        Name = "google_earth.ico"
        Mode = "Install"
    },
    @{
        URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/digres.ico"
        Name = "digres.ico"
        Mode = "Install"
    }
)
$Icons | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default