$Shortcuts = @(
    @{
        Name            = "Printkode"
        Type            = "lnk"
        Path            = "C:\Program Files\internet explorer\iexplore.exe"
        Arguments       = "http://10.82.24.82/kode"
        WorkingDir      = "C:\Program Files\internet explorer\"
        IconFileandType = "C:\Windows\System32\imageres.dll, 46"
        Description     = "Printkode"
    },
    @{
        Name            = "Veiledninger"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://info.hortenskolen.no"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\System32\imageres.dll, 76"
        Description     = "Diverse veiledinger"
    },
    @{
        Name            = "Digitale Ressurser"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://digres.hortenskolen.no"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\ICO\digres.ico"
        Description     = "Digitale Ressurser"
    }
)

$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default