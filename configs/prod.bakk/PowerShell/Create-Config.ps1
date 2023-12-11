$PowerShell = @(
    @{
        Name = "Disable Acer Quick Access"
        Command = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
        
    }
    @{
        Name      = "Remove Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Remove-Item -Path ('C:\Users\' + `$Username + '\Desktop\Microsoft Teams (work or school).lnk')"
        Detection = "`$false"
    },
    @{
        Name      = "Remove Teams Shortcut"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'AzureAD\\', ''); Set-Variable Username -Value (`$Username -replace 'Skole\\', ''); Remove-item -Path ('C:\Users\' + `$Username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams classic (work or school).lnk')"
        Detection = "`$false"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default
