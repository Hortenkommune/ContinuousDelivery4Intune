$PowerShell = @(
    @{
        Name      = "Disable Restart-Computer every night"
        Command   = "Get-ScheduledTask -TaskName 'Nightly Reboot' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot' | Where-Object {`$_.State -eq 'Disabled'})"
    },
    @{
        Name      = "Add Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Copy-Item -Path ('C:\Users\' + `$Username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams (work or school).lnk') -Destination ('C:\Users\' + `$Username + '\Desktop')"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"AzureAD\\`",`"`";[bool]((Test-Path `"C:\Users\`$Username\Desktop\Microsoft Teams (work or school).lnk`"))"
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
        Name = "Disable Acer Quick Access"
        Command = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default
