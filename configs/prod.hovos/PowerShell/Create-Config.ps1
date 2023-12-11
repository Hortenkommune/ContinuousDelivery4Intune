$PowerShell = @(
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
        Name      = "Remove desktop.ini from OneDrive"
        Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item ('C:\Users\' + `$Username + '\OneDrive - Horten kommune\desktop.ini') -Force"
        Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(Test-Path `"C:\Users\`$Username\OneDrive - Horten kommune\desktop.ini`"))"
    }
)
$PowerShell | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default