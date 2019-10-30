$Shortcuts = @(
    @{
        Name            = "Google Earth"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://earth.google.com/web"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\ICO\google_earth.ico"
        Description     = "Google Earth Cloud"
        Mode            = "Install"
    },
    @{
        Name            = "Printkode"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://hortenprint.intern.i-sone.no/mom/Auth/UsernamePasswordLogin"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\System32\imageres.dll, 46"
        Description     = "Printkode"
        Mode            = "Install"
    },
    @{
        Name            = "Veiledninger"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://info.hortenskolen.no"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\System32\imageres.dll, 76"
        Description     = "Diverse veiledinger"
        Mode            = "Install"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default