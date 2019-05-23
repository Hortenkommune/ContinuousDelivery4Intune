$runbook = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/runbook/beta/runbook.json" -UseBasicParsing
$FunctionPath = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/Functions/"

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