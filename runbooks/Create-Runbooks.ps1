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
                Function = "Resolve-Service"
                URI      = $config.functionsUri + "/Resolve-Service.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Services/all/config.json"
                    }
                )
            },
            @{
                Function = "New-ComputerName"
                URI      = $config.functionsUri + "/New-ComputerName.json"
            },
            @{
                Function = "Invoke-WindowsActivation"
                URI      = $config.functionsUri + "/Invoke-WindowsActivation.json"
            },
            @{
                Function = "Install-Chocolatey"
                URI      = $config.functionsUri + "/Install-Chocolatey.json"
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
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/usandbs/config.json"
                    },
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Chocolatey/system/config.json"
                    }
                )
            },
            @{
                Function = "Invoke-PowerShell"
                URI      = $config.functionsUri + "/Invoke-PowerShell.json"
                Config   = @( 
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/PowerShell/base/config.json"
                    }
                )            
            },
            @{
                Function = "Invoke-Sequence"
                URI      = $config.functionsUri + "/Invoke-Sequence.json"
                Config   = @( 
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Sequence/base/config.json"
                    }
                )
            },
            @{
                Function = "Install-Icon"
                URI      = $config.functionsUri + "/Install-Icon.json"
                Config   = @( 
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Icons/base/config.json"
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
                Function = "Install-RegFile"
                URI      = $config.functionsUri + "/Install-RegFile.json"
                Config   = @(
                    @{
                        cfguri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/configs/Regedit/base/config.json"
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