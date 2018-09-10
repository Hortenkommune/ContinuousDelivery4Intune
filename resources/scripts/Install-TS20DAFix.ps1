$Driver = Get-WindowsDriver -Online -All | Where-Object {$_.OriginalFileName -like "*valleyview2system.inf"} | Select-Object -ExpandProperty Driver

Expand-Archive -Path "C:\Windows\Temp\iaioi2ce.zip" -DestinationPath "C:\Windows\Temp\iaioi2ce"
$PnPUtil = "pnputil.exe"
$rmArg = "/delete-driver $Driver /uninstall /force"
$addArg = "/add-driver C:\Windows\Temp\iaioi2ce\iaioi2ce.inf /install"

Start-Process -FilePath $PnPUtil -ArgumentList $rmArg -Wait
Start-Process -FilePath $PnPUtil -ArgumentList $addArg -Wait

Remove-Item -Path "C:\Windows\Temp\iaioi2ce" -Recurse -Force