function New-SkyFunction {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [scriptblock]$Execute,
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function,
        [string]$FunctionPath = "$PSScriptRoot"
    )
    $SkyFunction = @{
        Name = $Name
        Execute = $Execute.ToString()
        Function = $Function.ToString()
    }
    $SkyFunction | ConvertTo-Json -Compress | Out-File (Join-Path -Path $FunctionPath -ChildPath "$Name.json") -Encoding default
}

New-SkyFunction -Name "New-ComputerName" -Function {
    function New-ComputerName {
        Write-Log -Value "Determing if ComputerName needs to change; Current name is: $($env:COMPUTERNAME)" -Severity 1 -Component "New-ComputerName"
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
        Write-Log -Value "Determing if ComputerName needs to change; Desired name is: $NewName" -Severity 1 -Component "New-ComputerName"
        $CurrentName = $env:COMPUTERNAME
        If (!($CurrentName -eq $NewName)) {
            Write-Log -Value "Changing ComputerName from $CurrentName to $NewName" -Severity 1 -Component "New-ComputerName"
            Rename-Computer -ComputerName $CurrentName -NewName $NewName
        }
        else {
            Write-Log -Value "ComputerName is already as desired; no action needed" -Severity 1 -Component "New-ComputerName"
        }
    }
} -Execute {
    New-ComputerName
}

New-SkyFunction -Name "Invoke-WindowsActivation" -Function {
    function Invoke-WindowsActivation {
        Write-Log -Value "Ensuring Windows 10 retail activation" -Severity 1 -Component "Invoke-WindowsActivation"
        $20DA = [bool](Get-WmiObject -Query "select * from win32_computersystem where model like '20DA%'")
        if ($20DA -eq $true) {
            Write-Log -Value "20DA detected as machinetype, need to use KMS activation" -Severity 1 -Component "Invoke-WindowsActivation"
            try {
                $ClientKey = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"
                $KMSHost = "10.82.17.21"
                $SLS = Get-WmiObject -Class "SoftwareLicensingService"
                $SLS.InstallProductKey($ClientKey)
                $SLS.SetKeyManagementServiceMachine($KMSHost)
                $SLS.RefreshLicenseStatus()
                Write-Log -Value "Windows 10 has been reactivated on KMS" -Severity 1 -Component "Invoke-WindowsActivation"
            }
            catch {
                Write-Log -Value "Windows 10 failed to reactivate on KMS" -Severity 3 -Component "Invoke-WindowsActivation"
            }
        }
        else {
            $SLP = Get-WmiObject -Class "SoftwareLicensingProduct" -Filter "KeyManagementServiceMachine = '10.85.16.21' OR DiscoveredKeyManagementServiceMachineIpAddress = '10.85.16.21'"
            if ($SLP) {
                Write-Log -Value "Need to convert to Windows 10 retail activation; initiating" -Severity 1 -Component "Invoke-WindowsActivation"
                try {
                    Write-Log -Value "Fetching OEM key" -Severity 1 -Component "Invoke-WindowsActivation"
                    $SLS = Get-WmiObject -Class "SoftwareLicensingService"
                    Write-Log -Value "OEM key fetched; uninstalling KMS key" -Severity 1 -Component "Invoke-WindowsActivation"
                    $SLP.UninstallProductKey()
                    $SLS.ClearProductKeyFromRegistry()
                    Write-Log -Value "KMS key uninstalled; installing fetched OEM key" -Severity 1 -Component "Invoke-WindowsActivation"
                    Start-Process "changepk.exe" -ArgumentList "/ProductKey $($SLS.OA3xOriginalProductKey)"
                    Write-Log -Value "Converted to Windows 10 retail activation" -Severity 1 -Component "Invoke-WindowsActivation"
                }
                catch {
                    Write-Log -Value "Failed to convert to Windows 10 retail activation" -Severity 3 -Component "Invoke-WindowsActivation"
                }
            }
            else {
                Write-Log -Value "No action needed; skipping" -Severity 1 -Component "Invoke-WindowsActivation"
            }
        }
    }
} -Execute {
    Invoke-WindowsActivation
}

New-SkyFunction -Name "Install-Chocolatey" -Function {
    function Install-Chocolatey {
        Write-Log -Value "Verifing Chocolatey installation" -Severity 1 -Component "Install-Chocolatey"
        $ChocoBin = $env:ProgramData + "\Chocolatey\bin\choco.exe"
        if (!(Test-Path -Path $ChocoBin)) {
            Write-Log -Value "$ChocoBin not detected; starting installation of chocolatey" -Severity 2 -Component "Install-Chocolatey"
            try {
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
            }
            catch {
                Write-Log -Value "Failed to install chocolatey" -Severity 3 -Component "Install-Chocolatey"
            }
        }
        else {
            Write-Log -Value "$ChocoBin detected; running upgrade sequence" -Severity 1 -Component "Install-Chocolatey"
            Invoke-Expression "cmd /c $ChocoBin upgrade all -y" -ErrorAction Stop
        }
    }
} -Execute {
    Install-Chocolatey
}

New-SkyFunction -Name "Register-ChocoSource" -Function {
    function Register-ChocoSource {
        param (
            $Name,
            $Server
        )
        $ChocoBin = $env:ProgramData + "\Chocolatey\bin\choco.exe"
        if (Test-Path -Path $ChocoBin) {
            $sources = Invoke-Expression "cmd /c $ChocoBin source"
            $regged = $false
            foreach ($s in $sources) {
                if ($s -like "$Name - $Server*") {
                    $regged = $true
                }
            }
            if ($regged -eq $false) {
                Write-Log -Value "$Name is not registered as chocosource; registering" -Severity 1 -Component "Register-ChocoSource"
                Invoke-Expression "cmd /c $ChocoBin source add --name=$Name --source=$Server --priority=0"
                Invoke-Expression "cmd /c $ChocoBin source add --name=chocolatey --source=https://chocolatey.org/api/v2/ --priority=1"
            }
            else {
                Write-Log -Value "$Name is already registered as chocosource; skipping" -Severity 1 -Component "Register-ChocoSource"
            }
        }
        else {
            Write-Log -Value "$ChocoBin not detected; chocolatey is not installed!!!! aborting" -Severity 3 -Component "Register-ChocoSource"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        Register-ChocoSource -Name $cfg.Name -Server $cfg.Server
    }
}

New-SkyFunction -Name "Invoke-Chocolatey" -Function {
    function Invoke-Chocolatey {
        param (
            $Application,
            $Mode
        )
        $ChocoBin = $env:ProgramData + "\Chocolatey\bin\choco.exe"
        Write-Log -Value "Running $Mode on $Application" -Severity 1 -Component "Invoke-Chocolatey"
        try {
            Invoke-Expression "cmd /c $ChocoBin $Mode $Application -y" -ErrorAction Stop
        }
        catch {
            Write-Log -Value "Failed to run $Mode on $Application" -Severity 3 -Component "Invoke-Chocolatey"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Invoke-Chocolatey -Application $i.Application -Mode $i.Mode
        }
    }
}

New-SkyFunction -Name "Install-SC" -Function {
    function Install-SC {
        param(
            $Name,
            $Type,
            $Path,
            $WorkingDir,
            $Arguments,
            $Description,
            $IconFileandType = $null
        )
        Write-Log -Value "Starting detection of $($Name)" -Severity 1 -Component "Install-SC"
        $LocalShortcutPath = ($env:PUBLIC + "\Desktop\$($Name).$($Type)")
        $ShellObj = New-Object -ComObject ("WScript.Shell")
        $Shortcut = $ShellObj.CreateShortcut($LocalShortcutPath)
        If (($Shortcut.Arguments -ne $Arguments) -or ($Shortcut.WorkingDirectory -ne $WorkingDir) -or ($Shortcut.Description -ne $Description) -or ($Shortcut.TargetPath -ne $Path)) {
            If ($Type -eq "lnk") {
                $verPath = $WorkingDir + "\" + $Path
                $Detection = Test-Path $verPath
                If (!($Detection)) {
                    $verPath = $Path
                    $Detection = Test-Path $verPath
                    If (!($Detection)) {
                        $verPath = $Path -split ' +(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'
                        $verPath = $verPath[0] -replace '"', ''
                        $Detection = Test-Path $verPath
                    }
                }
            }
            Else {
                $Detection = "url-file"
            }
            If ($Detection) {
                Write-Log -Value "$($Name) is not as configured; starting installation" -Severity 1 -Component "Install-SC"
                $Shortcut.TargetPath = "$($Path)"
                if ($Type -eq "url") {
                    $Shortcut.Save()
                    If ($IconFileandType) {
                        $IconSplit = $IconFileandType.Split(",").Trim()
                        $IconFile = "IconFile=" + $IconSplit[0]
                        $IconIndex = "IconIndex=" + $IconSplit[1]
                        Add-Content $LocalShortcutPath "HotKey=0"
                        Add-Content $LocalShortcutPath "$IconFile"
                        Add-Content $LocalShortcutPath "$IconIndex"
                    }
                }
                else {
                    If ($WorkingDir) {
                        $Shortcut.WorkingDirectory = "$($WorkingDir)";
                    }
                    If ($Arguments) {
                        $Shortcut.Arguments = "$($Arguments)";
                    }
                    If ($IconFileandType) {
                        $Shortcut.IconLocation = "$($IconFileandType)";
                    }
                    If ($Description) {
                        $Shortcut.Description = "$($Description)";
                    }
                    $Shortcut.Save()
                }
                Write-Log -Value "$($Name) is installed" -Severity 1 -Component "Install-SC"
            }
            else {
                Write-Log -Value "Can not detect $($Name) endpoint; skipping" -Severity 2 -Component "Install-SC"
            }
        }
        else {
            Write-Log -Value "$($Name) already exists; skipping" -Severity 1 -Component "Install-SC"    
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Install-SC -Name $i.Name -Type $i.Type -Path $i.Path -WorkingDir $i.WorkingDir -Arguments $i.Arguments -Description $i.Description -IconFileandType $i.IconFileandType
        }
    }
}

New-SkyFunction -Name "Install-Icon" -Function {
    function Install-Icon {
        param (
            $Name,
            $ExtLocation,
            $OutputPath = "C:\Windows\ICO"
        )
        if (!(Test-Path $OutputPath)) {
            New-Item -Path $OutputPath -ItemType Directory -Force
        }
        $IconPath = Join-Path -Path $OutputPath -ChildPath $Name
        if (!(Test-Path $IconPath)) {
            Write-Log -Value "$Name does not exist; Installing" -Severity 1 -Component "Install-Icon"
            Invoke-WebRequest -Uri $ExtLocation -OutFile $IconPath
        }
        else {
            Write-Log -Value "$Name is already installed" -Severity 1 -Component "Install-Icon"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Install-Icon -Name $i.Name -ExtLocation $i.URI
        }
    }
}

New-SkyFunction -Name "Invoke-Sequence" -Function {
    function Invoke-Sequence {
        param (
            [string]$Name,
            [psobject]$FilesToDownload,
            [psobject]$Execution,
            [psobject]$Detection,
            [string]$WorkingDirectory = "C:\Windows\Temp"
        )

        $DetectionRulesCount = $Detection | Measure-Object | Select-Object -ExpandProperty Count
        $DetectionCounter = 0

        Write-Log -Value "Starting detection of $Name" -Severity 1 -Component "Invoke-Sequence"

        foreach ($detect in $Detection) {
            $DetectionRule = $detect | Select-Object -ExpandProperty Rule
            $runDetectionRule = Invoke-Expression -Command $DetectionRule
            if ($runDetectionRule -eq $true) {
                $DetectionCounter++
            }
        }

        If (!($DetectionRulesCount -eq $DetectionCounter)) {
            Write-Log -Value "$Name is not detected; starting installation" -Severity 1 -Component "Invoke-Sequence"
            foreach ($download in $FilesToDownload) {
                $URL = $download | Select-Object -ExpandProperty URL
                $FileName = $download | Select-Object -ExpandProperty FileName
                Write-Log -Value "Downloading $URL" -Severity 1 -Component "Invoke-Sequence"
                Invoke-WebRequest -Uri $URL -OutFile (Join-Path -Path $WorkingDirectory -ChildPath $FileName)
                Write-Log -Value "$URL downloaded" -Severity 1 -Component "Invoke-Sequence"
            }
            foreach ($Execute in $Execution) {
                $Program = $Execute | Select-Object -ExpandProperty Execute
                $Arguments = $Execute | Select-Object -ExpandProperty Arguments
                Write-Log -Value "Executing $Program with arguments $Arguments" -Severity 1 -Component "Invoke-Sequence"
                Start-Process -FilePath $Program -ArgumentList $Arguments -Wait
                Write-Log -Value "$Program completed" -Severity 1 -Component "Invoke-Sequence"
            }
            foreach ($download in $FilesToDownload) {
                $FileName = $download | Select-Object -ExpandProperty FileName
                Remove-Item (Join-Path -Path $WorkingDirectory -ChildPath $FileName) -Force
            }
            Write-Log -Value "Installation of $Name completed" -Severity 1 -Component "Invoke-Sequence"
        }
        else {
            Write-Log -Value "$Name is already installed; skipping" -Severity 1 -Component "Invoke-Sequence"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Invoke-Sequence -Name $i.Name -FilesToDownload $i.FilesToDownload -Execution $i.Execution -Detection $i.Detection
        }
    }
}

New-SkyFunction -Name "Invoke-PowerShell" -Function {
    function Invoke-PowerShell {
        param (
            $Name,
            $Command,
            $Detection
        )
        Write-Log -Value "Detecting $Name" -Severity 1 -Component "Invoke-PowerShell"

        $runDetectionRule = Invoke-Expression -Command $Detection
        if (!($runDetectionRule -eq $true)) {
            $Arguments = "-Command $Command"
            Write-Log -Value "Starting powershell.exe with arguments: $Arguments" -Severity 1 -Component "Invoke-PowerShell"
            Start-Process -FilePath "powershell.exe" -ArgumentList $Arguments
        }
        else {
            Write-Log -Value "$Name is already run" -Severity 1 -Component "Invoke-PowerShell"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Invoke-PowerShell -Name $i.Name -Command $i.Command -Detection $i.Detection
        }
    }
}

New-SkyFunction -Name "Resolve-Service" -Function {
    function Resolve-Service {
        param (
            $Name,
            $DesiredState
        )
        $gSvc = Get-Service $Name
        Write-Log -Value "Checking if service $Name is set to $DesiredState" -Severity 1 -Component "Resolve-Service"
        if ($DesiredState -eq "Run") {
            if ($gSvc.Status -ne "Running") {
                Write-Log -Value "Service $Name is not running; starting" -Severity 2 -Component "Resolve-Service"
                Start-Service $Name
            }
        }
        else {
            if ($gSvc.Status -eq "Running") {
                Write-Log -Value "Service $Name is running; stopping" -Severity 2 -Component "Resolve-Service"
                Stop-Service $Name
            }
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Resolve-Service -Name $i.Name -DesiredState $i.DesiredState
        }
    }
}

New-SkyFunction -Name "Install-RegFile" -Function {
    function Install-RegFile {
        param (
            $URL,
            $detection,
            $Type
        )
        Write-Log -Value "Starting detection of Regedit settings; $URL" -Severity 1 -Component "Install-RegFile"
        $runDetectionRule = Invoke-Expression -Command $detection
        If (!($runDetectionRule -eq $true)) {
            Write-Log -Value "Regedit settings not detected; starting install; $URL" -Severity 1 -Component "Install-RegFile"
            $TempFile = Join-Path -Path $env:TEMP -ChildPath "TempRegFile.reg"
            Remove-Item $TempFile -Force -ErrorAction Ignore
            Invoke-WebRequest -Uri $URL -OutFile $TempFile
            $Arguments = "/s $TempFile"

            if ($Type -eq "HKCU") {
                Write-Log -Value "Regedit settings is HKCU; $URL" -Severity 1 -Component "Install-RegFile"
                $regfile = Get-Content $TempFile
                $hives = Get-ChildItem -Path REGISTRY::HKEY_USERS | Select-Object -ExpandProperty Name
                foreach ($hive in $hives) {
                    if (!($hive -like "*_Classes")) {
                        $newregfile = $regfile -replace "HKEY_CURRENT_USER", $hive
                        Set-Content -Path $TempFile -Value $newregfile
                        Start-Process "regedit.exe" -ArgumentList $Arguments -Wait
                    }
                }
            }
            elseif ($Type -eq "HKLM") {
                Write-Log -Value "Regedit settings is HKLM; $URL" -Severity 1 -Component "Install-RegFile"
                Start-Process "regedit.exe" -ArgumentList $Arguments -Wait
            }
            
        }
        Else {
            Write-Log -Value "Regedit settings is detected, aborting install; $URL" -Severity 1 -Component "Install-RegFile"
        }
    }
} -Execute {
    param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        foreach ($i in $cfg) {
            Install-RegFile -URL $i.URL -detection $i.detection -Type $i.Type
        }
    }
}