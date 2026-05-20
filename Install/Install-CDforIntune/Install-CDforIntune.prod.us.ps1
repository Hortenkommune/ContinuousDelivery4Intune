Param(
    $BranchName = "prod.us",
    $WaitFor = $null,
    $CleanUp = $false
)

If (!($WaitFor -eq $null)) {
    Do {
        $proc = Get-Process -Id $WaitFor
    }
    Until ($proc -eq $null)
}

$cfg = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/versioncontrol/config.json" -UseBasicParsing

$cfg = $cfg | Where-Object { $_.Name -eq $BranchName }

If (!(Test-Path "C:\Windows\Scripts")) {
    New-Item "C:\Windows\Scripts" -ItemType Directory
}

$ScriptLocURI = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/Install/CDforIntuneScript/Script.$($cfg.Name).ps1"

Invoke-WebRequest -Uri $ScriptLocURI -OutFile "C:\Windows\Scripts\Start-ContinuousDelivery.ps1" -UseBasicParsing

$ScheduledTaskName = "Continuous delivery for Intune"
$ScheduledTaskVersion = "$($cfg.Name) $($cfg.Version)"
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-Executionpolicy Bypass -File `"C:\Windows\Scripts\Start-ContinuousDelivery.ps1`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -Action $Action -Trigger $Trigger -User $User -RunLevel Highest -Settings $Settings -TaskName $ScheduledTaskName -Description $ScheduledTaskVersion -Force
Start-ScheduledTask -TaskName $ScheduledTaskName

If ($CleanUp -eq $true) {
    Remove-Item "$env:TEMP\Install-CDforIntune.ps1" -Force
}