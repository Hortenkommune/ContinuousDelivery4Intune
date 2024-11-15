﻿$PowerShell = @(
    #@{
    #    Name      = "Remove VNC from Start Menu"
    #    Command   = "Remove-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC' -Recurse -Force"
    #    Detection = "[bool](!(Test-Path -Path `"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC`"))"
    #},
    #@{
    #    Name      = "Add Restart-Computer every night"
    #    Command   = "Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Command Restart-Computer -Force') -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00pm) -User 'SYSTEM' -RunLevel Highest -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -WakeToRun) -TaskName 'Nightly Reboot' -Description 'Restart Computer nightly'"
    #    Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot')"
    #},
    @{
        Name      = "Add Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Copy-Item -Path ('C:\Users\' + `$Username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams (work or school).lnk') -Destination ('C:\Users\' + `$Username + '\Desktop')"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"AzureAD\\`",`"`"; `$Username = `$Username -replace `"Skole\\`",`"`";[bool]((Test-Path `"C:\Users\`$Username\Desktop\Microsoft Teams (work or school).lnk`"))"
    },
    @{
        Name      = "Remove Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Remove-Item -Path ('C:\Users\' + `$Username + '\Desktop\Microsoft Teams (work or school).lnk')"
        Detection = "`$false"
    },
    @{
        Name      = "Remove Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Remove-item -Path ('C:\Users\' + `$Username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams classic (work or school).lnk')"
        Detection = "`$false"
    },
    @{
        Name      = "Disable Restart-Computer every night"
        Command   = "Get-ScheduledTask -TaskName 'Nightly Reboot' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot' | Where-Object {`$_.State -eq 'Disabled'})"
    },
    # @{
    #     Name      = "Remove desktop.ini from OneDrive"
    #     Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item ('C:\Users\' + `$Username + '\OneDrive - Horten kommune\desktop.ini') -Force"
    #     Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(Test-Path `"C:\Users\`$Username\OneDrive - Horten kommune\desktop.ini`"))"
    # },
    # @{
    #     Name      = "Remove OneNote UWP Cache"
    #     Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item -Path ('C:\Users\' + `$Username + '\AppData\Local\Packages\Microsoft.Office.OneNote_8wekyb3d8bbwe\LocalState\AppData\Local\OneNote\16.0\') -Recurse -Force; Remove-Item -Path ('C:\Users\' + `$Username + '\AppData\Local\Packages\Microsoft.Office.OneNote_8wekyb3d8bbwe\Settings\settings.dat') -Force"
    #     Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(`$Username -like `"eksamen*`"))"
    # },
    #@{
    #    Name      = "Remove old printers"
    #    Command   = "@('2FL02588', '2FL07038', 'QLC31644', 'XVC08019', 'XVF14345', 'QNW11407', 'HK-ELEVv1') | ForEach-Object { if (Get-Printer -Name `$_) { Remove-Printer -Name `$_ } }" 
    #    Detection = "[bool](!(Get-Printer | Where-Object { @('2FL02588', '2FL07038', 'QLC31644', 'XVC08019', 'XVF14345', 'QNW11407', 'HK-ELEVv1') -contains `$_.Name }))"
    #},
    @{
        Name      = "Intune Sync"
        Command   = "Get-ScheduledTask | Where-Object {`$_.TaskName -eq 'PushLaunch' } | Start-ScheduledTask" 
        Detection = "`$false"
    },
    # @{
    #     Name      = "Remove Internet Exploder"
    #     Command   = "Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 -Online -NoRestart" 
    #     Detection = "[bool]((Get-WindowsOptionalFeature -Online | Where-Object {`$_.FeatureName -eq 'Internet-Explorer-Optional-amd64'}).State -eq 'Disabled')"
    # },
    #@{
    #    Name      = "Run DevCon64"
    #    Command   = "Start-Process `"devcon64`" -ArgumentList `"update`",`"C:\windows\inf\hdaudio.inf`",'\`"`"HDAUDIO\FUNC_01&VEN_10EC&DEV_0283\`"`"'"
    #    Detection = "[bool](!(Get-WmiObject -Query `"select * from win32_computersystem where model like '20DA%'`")) -or ((Get-PnpDevice `"HDAUDIO\FUNC_01&VEN_10EC&DEV_0283*`").FriendlyName -like `"High Definition*`")"
    #},
    #@{
    #    Name      = "Pin Audacity to 2.4.2"
    #    Command   = "choco pin add -n=audacity --version 2.4.2"
    #    Detection = "`$false"
    #},
    @{
        Name      = "Disable Acer Quick Access"
        Command   = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
    },
    @{
        Name      = "Set PowerCfg MinProcState"
        Command   = "Start-Process -FilePath `"powercfg.exe`" -ArgumentList '/SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_PROCESSOR PROCTHROTTLEMIN 100' -Wait; Start-Process -FilePath `"powercfg.exe`" -ArgumentList '/SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_PROCESSOR PROCTHROTTLEMIN 100' -Wait"
        Detection = "[bool]`$false"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default