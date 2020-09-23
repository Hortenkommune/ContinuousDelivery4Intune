$Shortcuts = @(
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
        Name            = "NRK Super"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://nrksuper.no/`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\nrk_super.ico"
        Description     = "NRK Super TV"
        Mode            = "Install"
    },
    @{
        Name            = "YouTube"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://www.youtube.com/`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\youtube.ico"
        Description     = "YouTube"
        Mode            = "Install"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default