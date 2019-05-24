$config = @{
    runbooksUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/runbooks"
    functionsUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/functions"
}

$runbooks = @(
    @{
        Name = "beta"
        Actions = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
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
)

$rbs = @()
foreach ($runbook in $runbooks) {
    $runbook | ConvertTo-Json -Depth 4 -Compress | Out-File $PSScriptRoot\$($runbook.Name).json -Encoding default
    $rbs += New-Object psobject -Property @{
        Name = $runbook.Name
        URI = ($config.runbooksUri + "/" + $runbook.Name + ".json")
    }
}
$rbs | ConvertTo-Json -Compress | Out-File $PSScriptRoot\runbooks.json -Encoding default