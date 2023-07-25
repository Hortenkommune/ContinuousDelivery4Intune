$PowerShell = @(
    @{
        Name      = "Disable Restart-Computer every night"
        Command   = "Get-ScheduledTask -TaskName 'Nightly Reboot' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot' | Where-Object {`$_.State -eq 'Disabled'})"
    },
    @{
        Name      = "Remove desktop.ini from OneDrive"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item ('C:\Users\' + `$Username + '\OneDrive - Horten kommune\desktop.ini') -Force"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(Test-Path `"C:\Users\`$Username\OneDrive - Horten kommune\desktop.ini`"))"
    },
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
