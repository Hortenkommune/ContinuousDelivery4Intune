$CustomExec = @(
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
        Name           = "Fix 20DA Microphone"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-MIC20DAFix.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-MIC20DAFix.ps1"
            },
            @{
                FileName = "20DAMicDrv.zip"
                URL      = "http://horten.kommune.no:83/filer/20DAMicDrv.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-MIC20DAFix.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like '20DA%'`")) -or (Get-WmiObject -Query `"select * from win32_PnPSignedDriver where DeviceName like 'Realtek High Definition Audio' and DriverVersion like '6.0.1.8186'`")"
            }
        )
    },
    @{
        Name           = "Upgrade Graphics Driver on Acer BR118-RN"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-HD505Graphics.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-HD505Graphics.ps1"
            },
            @{
                FileName = "vga6286.zip"
                URL      = "http://horten.kommune.no:83/filer/VGA6286.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-HD505Graphics.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like 'TravelMate Spin B118-RN'`")) -or ((Get-WmiObject -Query `"select * from win32_PnPSignedDriver where DeviceName like 'Intel(R) HD Graphics'`") | where {`$_.driverversion -ge '24.20.100.6286'})"
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
                Rule = "[bool](`$False)"              
            }
        )
    },
    @{
        Name           = "Install uniFlow printer"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-UniflowPrinter.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-UniflowPrinter.ps1"
            },
            @{
                FileName = "uniflow_pclxl.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/uniflow_pclxl.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-UniflowPrinter.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS;`$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username; `$ObjUser = New-Object System.Security.Principal.NTAccount(`$Username);`$SID = `$Objuser.Translate([System.Security.Principal.SecurityIdentifier]) | Select-Object -ExpandProperty Value;[bool]((Get-Printer -Name `"HortenPrintElev`") -and (Test-Path `"HKU:\`$SID\Software\Wow6432Node\NT-Ware\MOMUD`"))"
            }
        )
    }
)
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default