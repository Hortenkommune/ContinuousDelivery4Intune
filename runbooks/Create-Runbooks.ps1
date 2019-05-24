$config = @{
    runbooksUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/runbooks"
    functionsUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/functions"
}

$runbooks = @(
    @{
        Name          = "beta"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/O365/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/all/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/usandbs/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/geogebra/config.json"
                    }
                )
            }
        )
    },
    @{
        Name          = "prod.bs"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/O365/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/all/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/usandbs/config.json"
                    }
                )
            }
        )
    },
    @{
        Name          = "prod.us"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/O365/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/all/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/usandbs/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/geogebra/config.json"
                    }
                )
            }
        )
    },
    @{
        Name          = "prod.bakk"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/O365/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/all/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/bakkandhov/config.json"
                    }
                )
            }
        )
    }, 
    @{
        Name          = "prod.hovos"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-SC"
                URI      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/Install-SC.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/O365/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/all/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Shortcuts/bakkandhov/config.json"
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