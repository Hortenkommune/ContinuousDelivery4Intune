$SkyFunctions = @(
    @{
        Name     = 'Install-SC'
        Config   = "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/configs/beta/Shortcuts/config.json"
        Function = {
            function Install-SC {
                Param(
                    $Name,
                    $Type,
                    $Path,
                    $Arguments,
                    $Description
                )
                Write-Log -Value "Starting detection of $($Name)" -Severity 1 -Component "SC"
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
                        Write-Log -Value "$($Name) is not as configured; starting installation" -Severity 1 -Component "SC"
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
                        Write-Log -Value "$($Name) is installed" -Severity 1 -Component "SC"
                    }
                    else {
                        Write-Log -Value "Can not detect $($Name) endpoint; skipping" -Severity 2 -Component "SC"
                    }
                }
                else {
                    Write-Log -Value "$($Name) already exists; skipping" -Severity 1 -Component "SC"    
                }
            }
        }.Ast.ToString()
    }
)

$SkyFunctions | ConvertTo-Json | Out-File $PSScriptRoot\config.json