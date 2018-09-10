$CustomExec = @(
    @{
        Name           = "Deploy printer"
        FilesToDwnload = @(
            @{
                FileName = "Install-HKELEVv1.ps1"
                URL      = "http://sublog.org/storage/Install-HKELEVv1.ps1"
            },
            @{
                FileName = "cnlb0m.zip"
                URL      = "http://sublog.org/storage/cnlb0m.zip"
            },
            @{
                FileName = "lprport.reg"
                URL      = "http://sublog.org/storage/lprport.reg"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File 'C:\Windows\Temp\Install-HKELEVv1.ps1'"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](Get-WmiObject -Query `"select * from win32_printer where name like '%HK-ELEVv1%'`")"
            }
        )
        wrkDir         = "C:\Windows\Temp"
    },
    @{
        Name           = "Fix 20DA Touchscreen"
        FilesToDwnload = @(
            @{
                FileName = "Install-TS20DAFix.ps1"
                URL      = "https://raw.githubusercontent.com/Forsbakk/Intune-Application-Installers/master/Custom%20Scripts/Install-TS20DAFix.ps1"
            },
            @{
                FileName = "iaioi2ce.zip"
                URL      = "http://sublog.org/storage/iaioi2ce.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File `"C:\Windows\Temp\Install-TS20DAFix.ps1`""
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like '20DA%'`")) -or (Get-WmiObject -Query `"select * from win32_PnPSignedDriver where DeviceName like 'I2C Controller'`")"
            }
        )
        wrkDir         = "C:\Windows\Temp"
    }
)
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default