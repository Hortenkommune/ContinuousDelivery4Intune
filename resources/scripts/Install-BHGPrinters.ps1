$InstallPath = $env:PROGRAMFILES + "\HK-BHG"
$PrinterDriverInf = "CNLB0MA64.INF"
$InstallDriverPath = $InstallPath + "\" + $PrinterDriverInf
$ZipFile = $env:windir + "\temp\gpb0.zip"
$PrinterDriver = "Canon Generic Plus UFR II"
$Users = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
$Users = $Users.Replace("AzureAD\", "")

Expand-Archive -Path $ZipFile -DestinationPath $InstallPath -Force
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait
Add-PrinterDriver -Name $PrinterDriver
 
if ($Users -eq "GartnerlokkaSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.147.9" -Name "Gartnerløkka" 
    Add-Printer -Name "Gartnerløkka - Printer" -PortName "Gartnerløkka" -DriverName $PrinterDriver 
}
if ($Users -eq "BjornestienSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.119.15" -Name "Bjørnestien"
    Add-PrinterPort -PrinterHostAddress "10.85.119.4" -Name "Bjørnestien2"
    Add-Printer -Name "Bjørnestien - Printer" -PortName "Bjørnestien" -DriverName $PrinterDriver 
    Add-Printer -Name "Bjørnestien2 - Printer" -PortName "Bjørnestien2" -DriverName $PrinterDriver 
}
if ($Users -eq "NordskogenSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.121.7" -Name "Nordskogen"
    Add-Printer -Name "Nordskogen - Printer" -PortName "Nordskogen" -DriverName $PrinterDriver 
}
if ($Users -eq "StrandparkenSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.123.7" -Name "Strandparken"
    Add-PrinterPort -PrinterHostAddress "10.85.123.9" -Name "Strandparken(Hvilerom)"
    Add-Printer -Name "Strandparken - Printer" -PortName "Strandparken" -DriverName $PrinterDriver 
    Add-Printer -Name "Strandparken(Hvilerom) - Printer" -PortName "Strandparken(Hvilerom)" -DriverName $PrinterDriver 
}
if ($Users -eq "AsgardenSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.118.7" -Name "Asgarden(Lønneveien)"
    Add-PrinterPort -PrinterHostAddress "10.85.122.6" -Name "Asgarden(Nygårdsløkka)"
    Add-Printer -Name "Åsgarden (Lønneveien) - Printer" -PortName "Asgarden(Lønneveien)" -DriverName $PrinterDriver 
    Add-Printer -Name "Åsgarden (Nygårdsløkka) - Printer" -PortName "Asgarden(Nygårdsløkka)" -DriverName $PrinterDriver
}
if ($Users -eq "KarljohansvernSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.148.7" -Name "Karljohansvern"
    Add-Printer -Name "Karljohansvern - Printer" -PortName "Karljohansvern" -DriverName $PrinterDriver 
}
if ($Users -eq "BlaberlyngenSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.146.19" -Name "Blaberlyngen"
    Add-PrinterPort -PrinterHostAddress "10.85.146.17" -Name "Blaberlyngen(Gang)"
    Add-Printer -Name "Blåberlyngen - Printer" -PortName "Blaberlyngen" -DriverName $PrinterDriver 
    Add-Printer -Name "Blåberlyngen(Gang) - Printer" -PortName "Blaberlyngen(Gang)" -DriverName $PrinterDriver
}
if ($Users -eq "SkavliSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.152.18" -Name "Skavli"
    Add-Printer -Name "Skavli - Printer" -PortName "Skavli" -DriverName $PrinterDriver 
}
if ($Users -eq "RorehagenSA") {
    Add-PrinterPort -PrinterHostAddress "10.85.151.17" -Name "Rorehagen"
    Add-Printer -Name "Rørehagen - Printer" -PortName "Rorehagen" -DriverName $PrinterDriver 
}

Remove-Item -Path $InstallPath -Force -Recurse
