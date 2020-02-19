﻿$Choco = @(
    @{
        Application = "sccmtoolkit"
        Mode        = "install"
    },
    @{
        Application = "dotnet3.5"
        Mode        = "install"
    }
)

$Choco | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default