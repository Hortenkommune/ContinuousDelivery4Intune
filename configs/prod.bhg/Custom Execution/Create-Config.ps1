$CustomExec = @(
    @{
        Name           = "Deploy printers"
        wrkDir         = "C:\Windows\Temp"
        FilesToDwnload = @(
            @{
                FileName = "Install-BHGPrinters.ps1"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/scripts/Install-BHGPrinters.ps1"
            },
            @{
                FileName = "gpb0.zip"
                URL      = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/bin/gpb0.zip"
            }
        )
        Execution      = @(
            @{
                Execute   = "powershell.exe"
                Arguments = "-ExecutionPolicy Bypass -File C:\Windows\Temp\Install-BHGPrinters.ps1"
            }
        )
        Detection      = @(
            @{
                Rule = "[bool](Get-WmiObject -Query `"select * from win32_printer where name like '%Printer%'`")"
            }
        )
    }
)
$CustomExec | ConvertTo-Json -Depth 4 -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default