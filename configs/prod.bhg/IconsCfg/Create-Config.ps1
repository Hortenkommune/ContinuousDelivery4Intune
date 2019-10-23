$Icons = @(
 @{
    URI  = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/nrk_super.ico"
    Name = "nrk_super.ico"
    Mode = "Install"
},
@{
    URI = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/youtube.ico"
    Name = "youtube.ico"
    Mode = "Install"
}
)
$Icons | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default