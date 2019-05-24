#INITIAL CONFIGURATION
$runbookname = "beta"
$runbooksuri = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/runbooks/runbooks.json"

$runbooks = Invoke-RestMethod -Uri $runbooksuri -UseBasicParsing
$rbtoRun = $runbooks | Where-Object { $_.Name -eq $runbookname }
$runbook = Invoke-RestMethod -Uri $rbtoRun.URI -UseBasicParsing
#INITIAL CONFIGURATION END

#ACTION
foreach ($action in $runbook.Actions) {
    $function = Invoke-RestMethod -Uri "$FunctionPath/$($action.Function).json" -UseBasicParsing
    $funcexecSB = [scriptblock]::Create($function.Execute)
    $exec = $null
    foreach ($cfg in $action.Config) {
        [string]$exec += "Invoke-Command -ScriptBlock { $funcexecSB } -ArgumentList $($cfg.cfguri)`n"
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