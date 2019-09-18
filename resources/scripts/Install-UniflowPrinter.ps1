#Get UPN
$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username
$ObjUser = New-Object System.Security.Principal.NTAccount($Username)
$SID = $Objuser.Translate([System.Security.Principal.SecurityIdentifier])
$UPN = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$($SID.value)\IdentityCache\$($SID.value)" -Name "UserName"

#Print Driver
$ZipFile = "C:\Windows\Temp\uniflow_pclxl.zip"
Expand-Archive -Path $ZipFile -DestinationPath "$env:PROGRAMFILES\PrintDriver" -Force
$InstallDriverPath = "$env:PROGRAMFILES\PrintDriver\MomUdPclXl.inf"
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait

#Printer Object
$Printer = [PSCustomObject]@{
    Name           = "HortenPrintElev"
    PortName       = "HortenPrintElev"
    ServerHost     = "10.82.24.122"
    LprQueueName   = "HortenPrintElev"
    DriverName     = "uniFLOW Universal PCLXL Driver"
    PrintProcessor = "winprint"
}

#Installing Printer
Add-PrinterDriver -Name $Printer.DriverName
Add-PrinterPort -Name $Printer.PortName -LprHostAddress $Printer.ServerHost -LprQueueName $Printer.LprQueueName -LprByteCounting
Add-Printer -Name $Printer.Name -PortName $Printer.PortName -DriverName $Printer.DriverName -PrintProcessor $Printer.PrintProcessor

#Registry settings for CurrentUser
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
New-Item -Path "HKU:\$($SID.Value)\Software\Wow6432Node\NT-Ware\MOMUD" -Force
New-ItemProperty -Path "HKU:\$($SID.Value)\Software\Wow6432Node\NT-Ware\MOMUD" -Name "UPN" -Value $UPN -Force

#Registry settings for LocalMachine
$HKLMValue = "UPN=%Registry.HKEY_CURRENT_USER\SOFTWARE\Wow6432Node\NT-Ware\MOMUD\UPN%"

New-Item -Path "HKLM:\SOFTWARE\Nt-ware" -Name "MOMUD" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Nt-ware\MOMUD" -Name "AltUserIdent" -Value $HKLMValue -PropertyType "String" -Force
New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Nt-ware" -Name "MOMUD" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Nt-ware\MOMUD" -Name "AltUserIdent" -Value $HKLMValue -PropertyType "String" -Force

New-ItemProperty -Path "HKLM:\System\ControlSet001\Control\Print\Printers\$($Printer.Name)\PrinterDriverData\" -Name "Port" -Value "8000" -PropertyType "String" -Force
New-ItemProperty -Path "HKLM:\System\ControlSet001\Control\Print\Printers\$($Printer.Name)\PrinterDriverData\" -Name "Url" -Value "/pwclient/isapi/IcarusRequest.dll?script=showudoptions.icarus" -PropertyType "String" -Force
Set-ItemProperty -Path "HKLM:\System\ControlSet001\Control\Print\Printers\$($Printer.Name)\" -Name "Print Processor" -Value "winprint" -Force