Param(
    $BranchName = "prod.bakk",
    $WaitFor = $null,
    $CleanUp = $false
)

If (!($WaitFor -eq $null)) {
    Do {
        $proc = Get-Process -Id $WaitFor
    }
    Until ($proc -eq $null)
}

$cfg = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinousDelivery4Intune/master/versioncontrol/config.json"

$cfg = $cfg | Where-Object { $_.Name -eq $BranchName }

If (!(Test-Path "C:\Windows\Scripts")) {
    New-Item "C:\Windows\Scripts" -ItemType Directory
}

$ScriptLocURI = "https://raw.githubusercontent.com/Hortenkommune/ContinousDelivery4Intune/master/Install/CDforIntuneScript/Script.$($cfg.Name).ps1"

Invoke-WebRequest -Uri $ScriptLocURI -OutFile "C:\Windows\Scripts\Start-ContinuousDelivery.ps1"

$ScheduledTaskName = "Continuous delivery for Intune"
$ScheduledTaskVersion = "$($cfg.Name) $($cfg.Version)"
$ScheduledTask = Get-ScheduledTask -TaskName $ScheduledTaskName

if ($ScheduledTask) {
    Unregister-ScheduledTask -TaskPath "\" -TaskName $ScheduledTaskName -Confirm:$false
}

$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-Executionpolicy Bypass -File `"C:\Windows\Scripts\Start-ContinuousDelivery.ps1`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -Action $Action -Trigger $Trigger -User $User -RunLevel Highest -Settings $Settings -TaskName $ScheduledTaskName -Description $ScheduledTaskVersion
Start-ScheduledTask -TaskName $ScheduledTaskName

If ($CleanUp -eq $true) {
    Remove-Item "$env:TEMP\Install-CDforIntune.ps1" -Force
}
