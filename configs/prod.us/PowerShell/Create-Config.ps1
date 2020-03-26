$PowerShell = @(
    @{
        Name      = "Remove VNC from Start Menu"
        Command   = "Remove-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC' -Recurse -Force"
        Detection = "[bool](!(Test-Path -Path `"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC`"))"
    },
    @{
        Name      = "Add Restart-Computer every night"
        Command   = "Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Command Restart-Computer -Force') -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00pm) -User 'SYSTEM' -RunLevel Highest -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -WakeToRun) -TaskName 'Nightly Reboot' -Description 'Restart Computer nightly'"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot')"
    },
    @{
        Name      = "Remove desktop.ini from OneDrive"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item ('C:\Users\' + `$Username + '\OneDrive - Horten kommune\desktop.ini') -Force"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(Test-Path `"C:\Users\`$Username\OneDrive - Horten kommune\desktop.ini`"))"
    },
    @{
        Name      = "Remove OneNote UWP Cache"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item -Path ('C:\Users\' + `$Username + '\AppData\Local\Packages\Microsoft.Office.OneNote_8wekyb3d8bbwe\LocalState\AppData\Local\OneNote\16.0\') -Recurse -Force; Remove-Item -Path ('C:\Users\' + `$Username + '\AppData\Local\Packages\Microsoft.Office.OneNote_8wekyb3d8bbwe\Settings\settings.dat') -Force"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(`$Username -like `"eksamen*`"))"
    },
    #@{ REMOVED SINCE IT IS EKSAMENSTIME!!!!!
    #    Name      = "Remove old printers"
    #    Command   = "@('2FL02588', '2FL07038', 'QLC31644', 'XVC08019', 'XVF14345', 'QNW11407', 'HK-ELEVv1') | ForEach-Object { if (Get-Printer -Name `$_) { Remove-Printer -Name `$_ } }" 
    #    Detection = "[bool](!(Get-Printer | Where-Object { @('2FL02588', '2FL07038', 'QLC31644', 'XVC08019', 'XVF14345', 'QNW11407', 'HK-ELEVv1') -contains `$_.Name }))"
    #},
    @{
        Name      = "Intune Sync"
        Command   = "Get-ScheduledTask | Where-Object {`$_.TaskName -eq 'PushLaunch' } | Start-ScheduledTask" 
        Detection = "`$false"
    },
    @{
        Name      = "Run DevCon64"
        Command   = "Start-Process `"devcon64`" -ArgumentList `"update`",`"C:\windows\inf\hdaudio.inf`",'\`"`"HDAUDIO\FUNC_01&VEN_10EC&DEV_0283\`"`"'"
        Detection = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like '20DA%'`")) -or ((Get-PnpDevice `"HDAUDIO\FUNC_01&VEN_10EC&DEV_0283*`").FriendlyName -like `"High Definition*`")"
    }
)
$PowerShell | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default