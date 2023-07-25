$PowerShell = @(
    # @{
    #     Name      = "Remove VNC from Start Menu"
    #     Command   = "Remove-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC' -Recurse -Force"
    #     Detection = "[bool](!(Test-Path -Path `"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\TightVNC`"))"
    # }
    # @{
    #     Name      = "Add Restart-Computer every night"
    #     Command   = "Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Command Restart-Computer -Force') -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00pm) -User 'SYSTEM' -RunLevel Highest -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -WakeToRun) -TaskName 'Nightly Reboot' -Description 'Restart Computer nightly'"
    #     Detection = "[bool](Get-ScheduledTask -TaskName 'Nightly Reboot')"
    # },
    # @{
    #     Name      = "Remove desktop.ini from OneDrive"
    #     Command   = "New-Variable Username -Value (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); Set-Variable Username -Value (`$Username -replace 'SKOLE\\', ''); Remove-Item ('C:\Users\' + `$Username + '\OneDrive - Horten kommune\desktop.ini') -Force"
    #     Detection = "`$Username = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username); `$Username = `$Username -replace `"SKOLE\\`",`"`";[bool](!(Test-Path `"C:\Users\`$Username\OneDrive - Horten kommune\desktop.ini`"))"
    # },
    # @{
    #     Name = "Pin Audacity to 2.4.2"
    #     Command = "choco pin add -n=audacity --version 2.4.2"
    #     Detection = "`$false"
    # },
    @{
        Name = "Disable Acer Quick Access"
        Command = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default
