$config = @{
    runbooksUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/runbooks"
    functionsUri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/functions"
}

$runbooks = @(
    @{
        Name          = "beta"
        Scriptversion = "v2sfbeta"
        Actions       = @(
            @{
                Function = "Install-Chocolatey"
                URI      = $config.functionsUri + "/Install-Chocolatey.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/settings.json"
                    }
                )
            },
            @{
                Function = "Register-ChocoSource"
                URI      = $config.functionsUri + "/Register-ChocoSource.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/settings.json"
                    }
                )
            },
            @{
                Function = "Invoke-Chocolatey"
                URI      = $config.functionsUri + "/Invoke-Chocolatey.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/chrome/config.json"
                    }, 
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/usandbs/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/system/config.json"
                    }
                )
            },
            @{
                Function = "Install-SC"
                URI      = $config.functionsUri + "/Install-SC.json"
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
            },
            @{
                Function = "Resolve-Service"
                URI      = $config.functionsUri + "/Resolve-Service.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Services/all/config.json"
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
                URI      = $config.functionsUri + "/Install-SC.json"
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
                URI      = $config.functionsUri + "/Install-SC.json"
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
                URI      = $config.functionsUri + "/Install-SC.json"
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
                URI      = $config.functionsUri + "/Install-SC.json"
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