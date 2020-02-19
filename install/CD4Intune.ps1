#INITIAL CONFIGURATION
$runbookname = "beta"
$scriptversion = "v2sfbeta"
$runbooksuri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/runbooks/runbooks.json"

$runbooks = Invoke-RestMethod -Uri $runbooksuri -UseBasicParsing
$rbtoRun = $runbooks | Where-Object { $_.Name -eq $runbookname }
$runbook = Invoke-RestMethod -Uri $rbtoRun.URI -UseBasicParsing
#INITIAL CONFIGURATION END

#NATIVE LOGGING FUNCTION
function Write-Log {
    Param(
        [string]$Value,
        [string]$Severity,
        [string]$Component = "CD4Intune",
        [string]$FileName = "CD4Intune.log"
    )
    $LogFilePath = "C:\Windows\Logs\" + $FileName
    $Time = -join @((Get-Date -Format "HH:mm:ss.fff"), "+", (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias))
    $Date = (Get-Date -Format "MM-dd-yyyy")
    $LogText = "<![LOG[$($Value)]LOG]!><time=""$($Time)"" date=""$($Date)"" component=""$($Component)"" context=""SYSTEM"" type=""$($Severity)"" thread=""$($PID)"" file="""">"
    try {
        Out-File -InputObject $LogText -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to append log entry to $FileName file. Error message: $($_.Exception.Message)"
    }
}
#NATIVE LOGGING FUNCTION END

#UPDATE CHECK
if ($scriptversion -ne $runbook.Scriptversion) {
    #doUpgrade()
}
#UPDATE CHECK END

#ACTION
foreach ($action in $runbook.Actions) {
    $function = Invoke-RestMethod -Uri $action.URI -UseBasicParsing
    $funcexecSB = [scriptblock]::Create($function.Execute)
    $exec = $null
    foreach ($cfg in $action.Config) {
        [string]$exec += "Invoke-Command -ScriptBlock { $funcexecSB } -ArgumentList $($cfg.cfguri)`n"
    }
    if ($exec -eq $null) {
        [string]$exec = "Invoke-Command -ScriptBlock { $funcexecSB }"
    }
    $execSB = [scriptblock]::Create($exec)
    $runSB = [scriptblock]::Create(
        @"
$($function.Function)
$($execSB)
"@
    )
    Invoke-Command -ScriptBlock $runSB
}
#ACTION END