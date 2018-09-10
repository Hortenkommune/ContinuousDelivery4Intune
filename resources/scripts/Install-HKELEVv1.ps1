$InstallPath = $env:PROGRAMFILES + "\HK-ELEV"
$PrinterDriverInf = "CNLB0MA64.INF"
$InstallDriverPath = $InstallPath + "\" + $PrinterDriverInf
$ZipFile = $env:windir + "\Temp\cnlb0m.zip"
$RegFile = $env:windir + "\Temp\lprport.reg"
$PrinterName = "HK-ELEVv1"
$PrinterDriver = "Canon Generic Plus UFR II"
$PrinterPortName = "10.85.207.8:hk-elev"
Enable-WindowsOptionalFeature -Online -FeatureName "Printing-Foundation-LPRPortMonitor"
Expand-Archive -Path $ZipFile -DestinationPath $InstallPath -Force
 
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait
Add-PrinterDriver -Name $PrinterDriver
Start-Process -FilePath "regedit.exe" -ArgumentList "/s `"$RegFile`"" -Wait
 
Restart-Service -Name "Spooler" -Force
Add-Printer -Name $PrinterName -PortName $PrinterPortName -DriverName $PrinterDriver
 
Remove-Item -Path $InstallPath -Force -Recurse