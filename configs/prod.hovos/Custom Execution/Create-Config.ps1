$CustomExec = @(
    @{
        Name           = "Enable Wake Timers"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Run-PwrcfgWakeTimers.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Run-PwrcfgWakeTimers.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Run-PwrcfgWakeTimers.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "`$OP = (powercfg /query SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d);[bool](`$OP -like `"*Current AC Power Setting Index: 0x00000001*`") -and (`$OP -like `"*Current DC Power Setting Index: 0x00000001*`")"
            }
        )
    },
    @{
        Name           = "CleanUp HOVOS Printers"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Remove-PrintersHOVOS.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Remove-PrintersHOVOS.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Remove-PrintersHOVOS.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "(!(Get-Printer | Where-Object { @('Rom 204 HOVOS', 'Rom 203 HOVOS', 'Rom 121 HOVOS', 'Rom 120 HOVOS') -contains `$_.Name }))"
            }
        )
    },
    @{
        Name           = "Deploy printers"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-HOVOSPrinters.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-HOVOSPrinters.ps1"
            },
            @{
                FileName = "gpcl6.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/gpcl6.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-HOVOSPrinters.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](Get-WmiObject -Query `"select * from win32_printer where name like '%Rom 120 - HOVOS%'`")"
            }
        )
    },
    @{
        Name           = "Install Language Capabilities"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-LangPacks.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-LangPacks.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-LangPacks.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "`$false"
            }
        )
    }
)
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default