$Branches = Get-Content "$PSScriptRoot\..\versioncontrol\config.json" -Raw | ConvertFrom-Json
$InstallerTemplate = Get-Content "$PSScriptRoot\Install-CDforIntune\Install-CDforIntune.ps1" -Raw

$Utf8Bom = [System.Text.UTF8Encoding]::new($true)

foreach ($b in $Branches) {
    $installer = $InstallerTemplate.Replace('$BranchName = ""', "`$BranchName = `"$($b.Name)`"")
    $installerPath = Join-Path $PSScriptRoot "Install-CDforIntune\Install-CDforIntune.$($b.Name).ps1"
    [System.IO.File]::WriteAllText($installerPath, $installer, $Utf8Bom)

    $scriptPath = Join-Path $PSScriptRoot "CDforIntuneScript\Script.$($b.Name).ps1"
    if (-not (Test-Path $scriptPath)) {
        Write-Warning "Missing runtime script: $scriptPath"
        continue
    }
    $script = Get-Content $scriptPath -Raw
    $synced = $script -replace '(?m)^\$Version = "[^"]*"', "`$Version = `"$($b.Version)`""
    if ($synced -ne $script) {
        [System.IO.File]::WriteAllText($scriptPath, $synced, $Utf8Bom)
    }
}
