#Print Driver
$ZipFile = "C:\Windows\Temp\cnlb0m.zip"
Expand-Archive -Path $ZipFile -DestinationPath "$env:PROGRAMFILES\PrintDriver" -Force
$InstallDriverPath = "$env:PROGRAMFILES\PrintDriver\CNLB0MA64.INF"
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait
Add-PrinterDriver -Name "Canon Generic Plus UFR II"