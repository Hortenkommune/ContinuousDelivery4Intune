$InstallPath = $env:PROGRAMFILES + "\HK-ELEV"
$PrinterDriverInf = "Cnp60MA64.INF"
$InstallDriverPath = $InstallPath + "\" + $PrinterDriverInf
$ZipFile = $env:windir + "\temp\gpcl6.zip"
$PrinterDriver = "Canon Generic PCL6 Driver"
 
$Printers = @(
    @{
        Name = "Rom 204 HOVOS"
        IP   = "10.85.200.19"
    }, 
    @{
        Name = "Rom 203 HOVOS"
        IP   = "10.85.200.37"
    },
    @{
        Name = "Rom 121 HOVOS"
        IP   = "10.85.200.49"
    }, 
    @{
        Name = "Rom 120 HOVOS"
        IP   = "10.85.200.45"
    }
)

Expand-Archive -Path $ZipFile -DestinationPath $InstallPath -Force
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait
Add-PrinterDriver -Name $PrinterDriver

Foreach ($Printer in $Printers) {
    Add-PrinterPort -PrinterHostAddress $Printer.IP -Name $Printer.Name
    Add-Printer -Name $Printer.Name -PortName $Printer.Name -DriverName $PrinterDriver
}    

Remove-Item -Path $InstallPath -Force -Recurse