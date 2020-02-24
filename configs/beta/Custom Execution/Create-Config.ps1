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
                Rule = "`$OP = (powercfg /query SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d);[bool](`$OP -like `"*Current AC Power Setting Index: 0x00000001*`") -and (`$OP -like `"*Current DC Power Setting Index: 0x00000001*`")"
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
    },
    @{
        Name           = "Set up eksamen printers"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-EksamenPrinters.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-EksamenPrinters.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-EksamenPrinters.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "if((Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username) -like `"*eksamen*`"){`$Install = `$true}elseif(Get-Printer | Where-Object {@('\\10.85.207.8\2FL02588','\\10.85.207.8\2FL07038','\\10.85.207.8\QLC31644','\\10.85.207.8\XVC08019','\\10.85.207.8\XVF14345','\\10.85.207.8\QNW11407') -contains `$_.Name }) {`$Install = `$true};[bool](!(`$Install -eq `$true))"
            }
        )
    },
    @{
        Name            = "Install Print Driver"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-UFRIIDriver.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-UFRIIDriver.ps1"
            },
            @{
                FileName = "cnlb0m.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/cnlb0m.zip"
            }
        )
        Execution       = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-UFRIIDriver.ps1"
            }
        )
        Detection       = @(
            @{
                Rule = "[bool](Get-PrinterDriver -Name `"Canon Generic Plus UFR II`")"
            }
        )
    }
)

$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default