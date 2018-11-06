$CustomExec = @(
    @{
        Name           = "Deploy printer"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-HKELEVv1.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-HKELEVv1.ps1"
            },
            @{
                FileName = "cnlb0m.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/cnlb0m.zip"
            },
            @{
                FileName = "lprport.reg"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/lprport.reg"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-HKELEVv1.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](Get-WmiObject -Query `"select * from win32_printer where name like '%HK-ELEVv1%'`")"
            }
        )
    },
    @{
        Name           = "Fix 20DA Touchscreen"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-TS20DAFix.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-TS20DAFix.ps1"
            },
            @{
                FileName = "iaioi2ce.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/iaioi2ce.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-TS20DAFix.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like '20DA%'`")) -or (Get-WmiObject -Query `"select * from win32_PnPSignedDriver where DeviceName like 'I2C Controller'`")"
            }
        )
    },
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
    }
)

$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default