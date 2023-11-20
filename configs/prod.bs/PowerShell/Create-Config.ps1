$PowerShell = @(
    # @{
    #     Name      = "Disable Restart-Computer every night"
    #     Command   = "Get-ScheduledTask -TaskName 'Nightly Reboot' | Disable-ScheduledTask"
    #     Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot' | Where-Object {`$_.State -eq 'Disabled'})"
    # },
    @{
        Name      = "Add Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Copy-Item -Path ('C:\Users\' + `$Username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams (work or school).lnk') -Destination ('C:\Users\' + `$Username + '\Desktop')"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"AzureAD\\`",`"`"; `$Username = `$Username -replace `"Skole\\`",`"`";[bool]((Test-Path `"C:\Users\`$Username\Desktop\Microsoft Teams (work or school).lnk`"))"
    },
    # @{
    #     Name      = "Intune Sync"
    #     Command   = "Get-ScheduledTask | Where-Object {`$_.TaskName -eq 'PushLaunch' } | Start-ScheduledTask" 
    #     Detection = "`$false"
    # },
    @{
        Name = "Disable Acer Quick Access"
        Command = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default
