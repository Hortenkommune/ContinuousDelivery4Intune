$Shortcuts = @(
    @{
        Name            = "Google Earth"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://earth.google.com/web`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\google_earth.ico"
        Description     = "Google Earth Cloud"
        Mode            = "Install"
    },
    @{
        Name            = "Office 365"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://portal.office.com`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\Office_portal.ico"
        Description     = "Office 365"
        Mode            = "Install"
    },
    @{
        Name            = "Word"
        Type            = "lnk"
        Path            = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
        WorkingDir      = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"
        IconFileandType = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk, 0"
        Description     = "Word"
        Mode            = "Install"
    },
    @{
        Name            = "Excel"
        Type            = "lnk"
        Path            = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
        WorkingDir      = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"
        IconFileandType = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk, 0"
        Description     = "Excel"
        Mode            = "Install"
    },
    @{
        Name            = "PowerPoint"
        Type            = "lnk"
        Path            = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
        WorkingDir      = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"
        IconFileandType = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk, 0"
        Description     = "PowerPoint"
        Mode            = "Install"
    },
    @{
        Name            = "Printkode"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://hortenprint.intern.i-sone.no/mom/Auth/UsernamePasswordLogin`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\System32\imageres.dll, 46"
        Description     = "Printkode"
        Mode            = "Install"
    },
    @{
        Name            = "Veiledninger"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://info.hortenskolen.no`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\System32\imageres.dll, 76"
        Description     = "Diverse veiledinger"
        Mode            = "Install"
    },
    @{
        Name            = "Digitale Ressurser"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://digres.hortenskolen.no`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\digres.ico"
        Description     = "Digitale Ressurser"
        Mode            = "Install"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default