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
        Name           = "Install Firewall rules"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Set-FirewallRule.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Set-FirewallRule.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Set-FirewallRule.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "`$false"
            }
        )
    },
    @{
        Name           = "Enable High Performance Mode"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Set-HighPerfmode.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Set-HighPerfmode.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Set-HighPerfmode.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](!(Test-Path -Path `"C:\Program Files\Lingdys4\lingx.exe`"))"              
            }
        )
    },
    @{
        Name           = "Update Intel Wi-Fi driver on Dell Pro 15 Essential PV15255"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "WiFi-24.70.0-Driver64-Win10-Win11.exe"
                URL      = "https://files.horten.kommune.no/cd4intune/WiFi-24.70.0-Driver64-Win10-Win11.exe"
            }
        )
        Execution      = @(
            @{
                Execute   = "C:\Windows\Temp\WiFi-24.70.0-Driver64-Win10-Win11.exe"
                Arguments = "-s -l C:\Windows\Logs\IntelWiFi-24.70.0.log"
            }
        )
        Detection      = @(
            @{
                Rule = "`$m = Get-WmiObject -Query `"select * from win32_computersystem where model like 'Dell Pro 15 Essential PV15255%'`";`$d = Get-WmiObject -Query `"select * from win32_PnPSignedDriver where DeviceClass='NET' and DeviceName like 'Intel(R) Wi-Fi%'`";[bool]((!`$m) -or (`$d | Where-Object { (`$_.DriverVersion -as [version]) -ge [version]'24.70.0.3' }))"
            }
        )
    },
    @{
        Name           = "Remove OEM McAfee on Dell Pro 15 Essential PV15255"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Remove-McAfee.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Remove-McAfee.ps1"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Remove-McAfee.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "`$m = Get-WmiObject -Query `"select * from win32_computersystem where model like 'Dell Pro 15 Essential PV15255%'`";`$clean = (!(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\McAfee.wps')) -and (!(Get-Service mc-fw-host -ErrorAction SilentlyContinue)) -and (!(Get-WmiObject Win32_SystemDriver -Filter `"Name='mfesec'`")) -and (!(Test-Path 'HKLM:\SOFTWARE\McAfee'));[bool]((!`$m) -or `$clean)"
            }
        )
    }
)
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default