$runbook = @{
    Name = "beta"
    Actions = @(
        @{
            Function = "Install-SC"
            Config = @(
                @{
                    cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/configs/Shortcuts/O365/config.json"
                },
                @{
                    cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/configs/Shortcuts/SchoolLinks/config.json"
                }
            )
        }
    )
}

$runbook | ConvertTo-Json -Depth 4 -Compress | Out-File $PSScriptRoot\runbook.json -Encoding default