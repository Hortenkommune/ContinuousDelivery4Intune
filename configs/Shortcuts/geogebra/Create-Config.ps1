$Shortcuts = @(
    @{
        Name            = "GeoGebra Online"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://www.geogebra.org/graphing"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\ICO\geogebra.ico"
        Description     = "GeoGebra Online"
        Mode            = "Install"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default