$BranchName = "beta"
$Version = "1.0.13.3"


function Write-Log {
    Param(
        [string]$Value,
        [string]$Severity,
        [string]$Component = "CD4Intune",
        [string]$FileName = "CD4Intune.log"
    )
    $LogFilePath = "C:\Windows\Logs" + "\" + $FileName
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


$cfg = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/versioncontrol/config.json" -UseBasicParsing
$cfg = $cfg | Where-Object { $_.Name -eq $BranchName }

if ($cfg.Version -eq $Version) {
    Write-Log -Value "Newest version already installed" -Severity 1 -Component "Update"
}
else {
    Write-Log -Value "Newer version found, upgrading" -Severity 1 -Component "Update"

    $ScriptLocURI = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/Install/Install-CDforIntune/Install-CDforIntune.ps1"
    Invoke-WebRequest -Uri $ScriptLocURI -OutFile "$env:TEMP\Install-CDforIntune.ps1"

    Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$env:TEMP\Install-CDforIntune.ps1`" -BranchName $BranchName -WaitFor $PID -CleanUp $true" -WindowStyle Hidden
    break
}

$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username
If ($Username -like "*eksamen*") {
    Write-Log -Value "Restricted user `"$Username`" detected; Enabling restricted mode" -Severity 1 -Component "Eksamen"
    $Username = $Username -split "\\"
    $objUser = New-Object System.Security.Principal.NTAccount("$($Username[0])", "$($Username[1])")
    $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
    $SID = $strSID.Value

    $hive = Get-ChildItem -Path REGISTRY::HKEY_USERS | Select-Object -ExpandProperty Name | Where-Object { $_ -like "*$SID" }
    Write-Log -Value "Writing restricted settings to hive: $hive" -Severity 1 -Component "Eksamen"

    $TempHKCUFile = $env:TEMP + "\TempHKCU.reg"
    Remove-Item $TempHKCUFile -Force -ErrorAction Ignore
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/regfiles/EksamenRegSettings.reg" -OutFile $TempHKCUFile

    $regfile = Get-Content $TempHKCUFile
    $newregfile = $regfile -replace "HKEY_CURRENT_USER", $hive

    Set-Content -Path $TempHKCUFile -Value $newregfile
    $Arguments = "/s $TempHKCUFile"

    Start-Process "regedit.exe" -ArgumentList $Arguments -Wait
    Write-Log -Value "Device is in restricted mode" -Severity 1 -Component "Eksamen"
}
else {
    Write-Log -Value "User `"$Username`" is not a restricted user; Continuing launch" -Severity 1 -Component "Eksamen"
}

$ServicesToStart = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/Services/config.json" -UseBasicParsing
foreach ($svc in $ServicesToStart) {
    $gSvc = Get-Service $svc.Name
    Write-Log -Value "Checking if service $($svc.Name) is set to $($svc.Mode)" -Severity 1 -Component "Services"
    if ($svc.Mode -eq "Run") {
        if ($gSvc.Status -ne "Running") {
            Write-Log -Value "Service $($svc.Name) is not running; starting" -Severity 2 -Component "Services"
            Start-Service $svc.Name
        }
    }
    else {
        if ($gSvc.Status -eq "Running") {
            Write-Log -Value "Service $($svc.Name) is running; stopping" -Severity 2 -Component "Services"
            Stop-Service $svc.Name
        }
    }
}

$SerialNumber = Get-WmiObject -Class Win32_bios | Select-Object -ExpandProperty SerialNumber
$Manufacturer = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer
If ($Manufacturer -eq "Acer") {
    $NewName = $SerialNumber.Substring(10, 12) -replace " "
    $NewName = "A" + $NewName
}
Else {
    If ($SerialNumber.Length -ge 15) {
        $NewName = $SerialNumber.Substring(0, 15) -replace " "
    }
    else {
        $NewName = $SerialNumber
    }
}
$CurrentName = $env:COMPUTERNAME
If (!($CurrentName -eq $NewName)) {
    Rename-Computer -ComputerName $CurrentName -NewName $NewName
}

Write-Log -Value "Ensuring Windows 10 retail activation" -Severity 1 -Component "slmgr"

$20DA = [bool](Get-WmiObject -Query "select * from win32_computersystem where model like '20DA%'")
if ($20DA -eq $true) {
    #Write-Log -Value "Reactivating Windows 10 on 20DA" -Severity 1 -Component "slmgr"
    #try {
    #    $ClientKey = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"
    #    $KMSHost = "10.82.17.21"
    #    $SLS = Get-WmiObject -Class "SoftwareLicensingService"
    #    $SLS.InstallProductKey($ClientKey)
    #    $SLS.SetKeyManagementServiceMachine($KMSHost)
    #    $SLS.RefreshLicenseStatus()
    #    Write-Log -Value "Windows 10 has been reactivated" -Severity 1 -Component "slmgr"
    #}
    #catch {
    #    Write-Log -Value "Windows 10 failed to reactivate" -Severity 3 -Component "slmgr"
    #}
}
else {
    $SLP = Get-WmiObject -Class "SoftwareLicensingProduct" -Filter "KeyManagementServiceMachine = '10.85.16.21' OR DiscoveredKeyManagementServiceMachineIpAddress = '10.85.16.21'"
    if ($SLP) {
        Write-Log -Value "Need to convert to Windows 10 retail activation; initiating" -Severity 1 -Component "slmgr"
        try {
            Write-Log -Value "Fetching OEM key" -Severity 1 -Component "slmgr"
            $SLS = Get-WmiObject -Class "SoftwareLicensingService"
            Write-Log -Value "OEM key fetched; uninstalling KMS key" -Severity 1 -Component "slmgr"
            $SLP.UninstallProductKey()
            $SLS.ClearProductKeyFromRegistry()
            Write-Log -Value "KMS key uninstalled; installing fetched OEM key" -Severity 1 -Component "slmgr"
            Start-Process "changepk.exe" -ArgumentList "/ProductKey $($SLS.OA3xOriginalProductKey)"
            Write-Log -Value "Converted to Windows 10 retail activation" -Severity 1 -Component "slmgr"
        }
        catch {
            Write-Log -Value "Failed to convert to Windows 10 retail activation" -Severity 3 -Component "slmgr"
        }
    }
    else {
        Write-Log -Value "No action needed; skipping" -Severity 1 -Component "slmgr"
    }
}

$ChocoBin = $env:ProgramData + "\Chocolatey\bin\choco.exe"

if (!(Test-Path -Path $ChocoBin)) {
    Write-Log -Value "$ChocoBin not detected; starting installation of chocolatey" -Severity 2 -Component "Chocolatey"
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    catch {
        Write-Log -Value "Failed to install chocolatey" -Severity 3 -Component "Chocolatey"
    }
}

Write-Log -Value "Upgrading chocolatey and all existing packages" -Severity 1 -Component "Chocolatey"
try {
    Invoke-Expression "cmd /c $ChocoBin source remove -n=hrtcloudchoco"
    Invoke-Expression "cmd /c $ChocoBin source add --name=nexus --source=http://10.82.24.21:10000/repository/chocolatey-group/ --priority=0"
    Invoke-Expression "cmd /c $ChocoBin source add --name=chocolatey --source=https://chocolatey.org/api/v2/ --priority=1"
    Invoke-Expression "cmd /c $ChocoBin upgrade all -y" -ErrorAction Stop
}
catch {
    Write-Log -Value "Failed to upgrade chocolatey and all existing packages" -Severity 3 -Component "Chocolatey"
}

$ChocoConf = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/Choco/config.json" -UseBasicParsing

ForEach ($ChockoPkg in $ChocoConf) {
    Write-Log -Value "Running $($ChockoPkg.Mode) on $($ChockoPkg.Name)" -Severity 1 -Component "Chocolatey"
    try {
        Invoke-Expression "cmd /c $ChocoBin $($ChockoPkg.Mode) $($ChockoPkg.Name) -y" -ErrorAction Stop
    }
    catch {
        Write-Log -Value "Failed to run $($ChockoPkg.Mode) on $($ChockoPkg.Name)" -Severity 3 -Component "Chocolatey"
    }
}

$Icons = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/IconsCfg/config.json" -UseBasicParsing
foreach ($ico in $Icons) {
    $IconPath = "C:\Windows\ICO\" + $ico.Name
    $IconFolderExist = Test-Path "C:\Windows\ICO"
    If (!$IconFolderExist) {
        New-Item -Path "C:\Windows\ICO" -ItemType Directory -Force
    }
    Write-Log -Value "Checking existance of $($ico.Name)" -Severity 1 -Component "IconsCfg"
    $exist = Test-Path $IconPath
    if ($ico.Mode -eq "Install") {
        if (!$exist) {
            Write-Log -Value "$($ico.Name) does not exist; Installing" -Severity 1 -Component "IconsCfg"
            Invoke-WebRequest -Uri $ico.URI -OutFile $IconPath
        }
        else {
            Write-Log -Value "$($ico.Name) is already installed" -Severity 1 -Component "IconsCfg"
        }
    }
    else {
        if ($exist) {
            Write-Log -Value "$($ico.Name) does exist; Uninstalling" -Severity 1 -Component "IconsCfg"
            Remove-Item $IconPath -Force
        }
        else {
            Write-Log -Value "$($ico.Name) is already uninstalled" -Severity 1 -Component "IconsCfg"
        }
    }
}

$AdvInstallers = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/Custom%20Execution/config.json" -UseBasicParsing

foreach ($AdvInst in $AdvInstallers) {

    [string]$Name = $AdvInst.Name
    [psobject]$FilesToDwnload = $AdvInst.FilesToDwnload
    [psobject]$Execution = $AdvInst.Execution
    [psobject]$Detection = $AdvInst.Detection
    [string]$wrkDir = $AdvInst.wrkDir

    $DetectionRulesCount = $Detection | Measure-Object | Select-Object -ExpandProperty Count
    $DetectionCounter = 0

    Write-Log -Value "Starting detection of $Name" -Severity 1 -Component "AdvancedApplication"

    foreach ($detect in $Detection) {
        $DetectionRule = $detect | Select-Object -ExpandProperty Rule
        $runDetectionRule = Invoke-Expression -Command $DetectionRule
        if ($runDetectionRule -eq $true) {
            $DetectionCounter++
        }
    }

    If (!($DetectionRulesCount -eq $DetectionCounter)) {
        Write-Log -Value "$Name is not detected; starting installation" -Severity 1 -Component "AdvancedApplication"
        foreach ($dwnload in $FilesToDwnload) {
            $URL = $dwnload | Select-Object -ExpandProperty URL
            $FileName = $dwnload | Select-Object -ExpandProperty FileName
            Write-Log -Value "Downloading $URL" -Severity 1 -Component "AdvancedApplication"
            Invoke-WebRequest -Uri $URL -OutFile $wrkDir\$FileName
            Write-Log -Value "$URL downloaded" -Severity 1 -Component "AdvancedApplication"
        }
        foreach ($Execute in $Execution) {
            $Program = $Execute | Select-Object -ExpandProperty Execute
            $Arguments = $Execute | Select-Object -ExpandProperty Arguments
            Write-Log -Value "Executing $Program with arguments $Arguments" -Severity 1 -Component "AdvancedApplication"
            Start-Process -FilePath $Program -ArgumentList $Arguments -Wait
            Write-Log -Value "$Program completed" -Severity 1 -Component "AdvancedApplication"
        }
        foreach ($dwnload in $FilesToDwnload) {
            $FileName = $dwnload | Select-Object -ExpandProperty FileName
            Remove-Item $wrkDir\$FileName -Force
        }
        Write-Log -Value "Installation of $Name completed" -Severity 1 -Component "AdvancedApplication"
    }
    else {
        Write-Log -Value "$Name is already installed; skipping" -Severity 1 -Component "AdvancedApplication"
    }
}


$PSs = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/PowerShell/config.json" -UseBasicParsing

foreach ($PS in $PSs) {
    $runDetectionRule = Invoke-Expression -Command $PS.Detection
    Write-Log -Value "Detecting $($PS.Name)" -Severity 1 -Component "PowerShell"
    if (!($runDetectionRule -eq $true)) {
        $Arguments = "-Command $($PS.Command)"
        Write-Log -Value "Starting powershell.exe with arguments: $Arguments" -Severity 1 -Component "PowerShell"
        Start-Process -FilePath "powershell.exe" -ArgumentList $Arguments
    }
    else {
        Write-Log -Value "$($PS.Name) is already run" -Severity 1 -Component "PowerShell"
    }
}


$SCConf = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/Shortcuts/config.json" -UseBasicParsing

ForEach ($SC in $SCConf) {
    If ($SC.Mode -eq "Uninstall") {
        Write-Log -Value "Starting deletion of $($SC.Name)" -Severity 1 -Component "SC"
        $FileToDelete = $env:PUBLIC + "\Desktop\$($SC.Name).$($SC.Type)"
        Remove-Item $FileToDelete -Force
        Write-Log -Value "$($SC.Name) deleted" -Severity 1 -Component "SC"
    }
    Elseif ($SC.Mode -eq "Install") {
        Write-Log -Value "Starting detection of $($SC.Name)" -Severity 1 -Component "SC"
        $LocalShortcutPath = ($env:PUBLIC + "\Desktop\$($SC.Name).$($SC.Type)")
        $ShellObj = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $ShellObj.CreateShortcut($LocalShortcutPath)
        If (($Shortcut.Arguments -ne $SC.Arguments) -or ($Shortcut.WorkingDirectory -ne $SC.WorkingDir) -or ($Shortcut.Description -ne $SC.Description) -or ($Shortcut.TargetPath -ne $SC.Path) -or (($Shortcut.IconLocation -split ",")[0]) -ne ($SC.IconFileandType -split ",")[0]) {
            If ($SC.Type -eq "lnk") {
                $verPath = $SC.WorkingDir + "\" + $SC.Path
                $Detection = Test-Path $verPath
                If (!($Detection)) {
                    $verPath = $SC.Path
                    $Detection = Test-Path $verPath
                    If (!($Detection)) {
                        $verPath = $SC.Path -split ' +(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'
                        $verPath = $verPath[0] -replace '"', ''
                        $Detection = Test-Path $verPath
                    }
                }
            }
            Else {
                $Detection = "url-file"
            }
            If ($Detection) {
                Write-Log -Value "$($SC.Name) is not as configured; starting installation" -Severity 1 -Component "SC"
                $Shortcut.TargetPath = "$($SC.Path)"
                if ($SC.Type -eq "url") {
                    $Shortcut.Save()
                    If ($SC.IconFileandType) {
                        $IconSplit = $SC.IconFileandType.Split(",").Trim()
                        $IconFile = "IconFile=" + $IconSplit[0]
                        $IconIndex = "IconIndex=" + $IconSplit[1]
                        Add-Content $LocalShortcutPath "HotKey=0"
                        Add-Content $LocalShortcutPath "$IconFile"
                        Add-Content $LocalShortcutPath "$IconIndex"
                    }
                }
                else {
                    If ($SC.WorkingDir) {
                        $Shortcut.WorkingDirectory = "$($SC.WorkingDir)";
                    }
                    If ($SC.Arguments) {
                        $Shortcut.Arguments = "$($SC.Arguments)";
                    }
                    If ($SC.IconFileandType) {
                        $Shortcut.IconLocation = "$($SC.IconFileandType)";
                    }
                    If ($SC.Description) {
                        $Shortcut.Description = "$($SC.Description)";
                    }
                    $Shortcut.Save()
                }
                Write-Log -Value "$($SC.Name) is installed" -Severity 1 -Component "SC"
            }
            else {
                Write-Log -Value "Can not detect $($SC.Name) endpoint; skipping" -Severity 2 -Component "SC"
            }
        }
        else {
            Write-Log -Value "$($SC.Name) already exists; skipping" -Severity 1 -Component "SC"    
        }
    }
}


$regfiles = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/$BranchName/Regedit/config.json" -UseBasicParsing

ForEach ($regfile in $regfiles) {
    Write-Log -Value "Starting detection of Regedit settings; $($regfile.URL)" -Severity 1 -Component "Regedit"
    $runDetectionRule = Invoke-Expression -Command $regfile.detection
    If (!($runDetectionRule -eq $true)) {
        Write-Log -Value "Regedit settings not detected; starting install; $($regfile.URL)" -Severity 1 -Component "Regedit"
        if ($regfile.Type -eq "HKLM") {
            Write-Log -Value "Regedit settings is HKLM; $($regfile.URL)" -Severity 1 -Component "Regedit"
            $TempHKLMFile = $env:TEMP + "\TempHKLM.reg"
            Remove-Item $TempHKLMFile -Force -ErrorAction Ignore
            Invoke-WebRequest -Uri $($regfile.URL) -OutFile $TempHKLMFile
            $Arguments = "/s $TempHKLMFile"
            Start-Process "regedit.exe" -ArgumentList $Arguments -Wait
            Remove-Item $TempHKLMFile -Force
            Write-Log -Value "HKLM file installed; $($regfile.URL)" -Severity 1 -Component "Regedit"
        }
        elseif ($regfile.Type -eq "HKCU") {
            Write-Log -Value "Regedit settings is HKCU; $($regfile.URL)" -Severity 1 -Component "Regedit"
            $TempHKCUFile = $env:TEMP + "\TempHKCU.reg"
            Remove-Item $TempHKCUFile -Force -ErrorAction Ignore
            Invoke-WebRequest -Uri $($regfile.URL) -OutFile $TempHKCUFile
            $regfile = Get-Content $TempHKCUFile
            $hives = Get-ChildItem -Path REGISTRY::HKEY_USERS | Select-Object -ExpandProperty Name
            foreach ($hive in $hives) {
                if (!($hive -like "*_Classes")) {
                    $newregfile = $regfile -replace "HKEY_CURRENT_USER", $hive
                    Set-Content -Path $TempHKCUFile -Value $newregfile
                    $Arguments = "/s $TempHKCUFile"
                    Start-Process "regedit.exe" -ArgumentList $Arguments -Wait
                }
            }
            Remove-Item $TempHKCUFile -Force
            Write-Log -Value "HKCU file installed; $($regfile.URL)" -Severity 1 -Component "Regedit"
        }
    }
    Else {
        Write-Log -Value "Regedit settings is detected, aborting install; $($regfile.URL)" -Severity 1 -Component "Regedit"
    }
}

Enable-WindowsOptionalFeature -Online -FeatureName "Printing-Foundation-LPRPortMonitor" -NoRestart
