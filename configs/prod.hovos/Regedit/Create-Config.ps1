﻿$regfiles = @(
    @{
        URL = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/DisableFirstRunIE.reg"
        detection = "[bool]((Get-ItemPropertyValue -Path `"HKLM:\Software\Microsoft\Internet Explorer\Main`" -Name DisableFirstRunCustomize) -eq 1)"
        Type = "HKLM"
    },
    @{
        URL = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/ShownFileFmtPrompt.reg"
        detection = "[bool]((Get-ItemPropertyValue -Path REGISTRY::HKEY_USERS\.DEFAULT\Software\Microsoft\Office\16.0\Common\General -Name ShownFileFmtPrompt) -eq 1)"
        Type = "HKCU"
    },
    @{
        URL = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/RemoveClarifyRun.reg"
        detection = "[bool](`$False)"
        Type = "HKCU"
    },
    @{
        URL = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/TrustedSites.reg"
        detection = "[bool](Test-Path -Path `"REGISTRY::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\kommune.no\adfs.horten`")"
        Type = "HKCU"
    },
    @{
        URL = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/ConnectionsTab.reg"
        detection = "[bool]((Get-ItemPropertyValue -Path `"REGISTRY::HKEY_USERS\.DEFAULT\Software\Policies\Microsoft\Internet Explorer\Control Panel`" -Name ConnectionsTab) -eq 1)"
        Type = "HKCU"
    }
)
$regfiles | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default