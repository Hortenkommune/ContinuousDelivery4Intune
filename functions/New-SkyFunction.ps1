function New-SkyFunction {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [scriptblock]$Execute,
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function,
        [string]$FunctionPath = ".\functions\"
    )
    $SkyFunction = @{
        Name = $Name
        Execute = $Execute.ToString()
        Function = $Function.ToString()
    }
    $SkyFunction | ConvertTo-Json -Compress | Out-File "$FunctionPath\$Name.json" -Encoding default
}

New-SkyFunction -Name "Install-Chocolatey" -Function {
    function Install-Chocolatey {
        Param(
            $Server
        )
        $ChocoBin = $env:ProgramData + "\Chocolatey\bin\choco.exe"
        if (!(Test-Path -Path $ChocoBin)) {
            Write-Log -Value "$ChocoBin not detected; starting installation of chocolatey" -Severity 2 -Component "Install-Chocolatey"
            try {
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('http://' + $Server + '/install.ps1'))
            }
            catch {
                Write-Log -Value "Failed to install chocolatey" -Severity 3 -Component "Install-Chocolatey"
            }
        }
        else {
            Write-Log -Value "$ChocoBin detected; chocolatey is already installed; running upgrade only" -Severity 1 -Component "Install-Chocolatey"
            Invoke-Expression "cmd /c $ChocoBin upgrade all -y" -ErrorAction Stop
        }
    }
} -Execute {
    Param(
        $cfguri = $null
    )
    if ($cfguri -ne $null) {
        $cfg = Invoke-RestMethod $cfguri -UseBasicParsing
        Install-Chocolatey -Server $cfg.Server
    }
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
                if ($s -like "$Name - http://$Server/chocolatey*") {
                    $regged = $true
                }
            }
            if ($regged -eq $false) {
                Write-Log -Value "$Name not registered as chocosource; registering" -Severity 1 -Component "Register-ChocoSource"
                Invoke-Expression "cmd /c $ChocoBin source add --name=$Name --source=http://$Server/chocolatey --priority=0"
                Invoke-Expression "cmd /c $ChocoBin source add --name=chocolatey --priority=1"
            }
            else {
                Write-Log -Value "$Name already registered as chocosource; skipping" -Severity 1 -Component "Register-ChocoSource"
            }
        }
        else {
            Write-Log -Value "$ChocoBin not detected; chocolatey is not installed!!!! aborting" -Severity 3 -Component "Register-ChocoSource"
        }
    }
} -Execute {
    Param(
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
        Param(
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