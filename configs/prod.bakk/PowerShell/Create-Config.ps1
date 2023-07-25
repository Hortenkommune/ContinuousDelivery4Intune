$PowerShell = @(
    @{
        Name = "Disable Acer Quick Access"
        Command = "Get-ScheduledTask -TaskName 'Software Update Application' | Disable-ScheduledTask"
        Detection = "[bool](Get-ScheduledTask -TaskName 'Software Update Application' | Where-Object {`$_.State -eq 'Disabled'})"
    }
)
$PowerShell | ConvertTo-Json -Compress -EscapeHandling EscapeHtml | Out-File "$PSScriptRoot\config.json" -Encoding default
