$Shortcuts = @(
    @{
        Name            = "Word"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Microsoft Office\root\Office16\winword.exe"
        WorkingDir      = "C:\Program Files (x86)\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files (x86)\Microsoft Office\root\Office16\winword.exe, 0"
        Description     = "Word 2016"
        Mode            = "Install"
    },
    @{
        Name            = "Excel"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Microsoft Office\root\Office16\excel.exe"
        WorkingDir      = "C:\Program Files (x86)\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files (x86)\Microsoft Office\root\Office16\excel.exe, 0"
        Description     = "Excel 2016"
        Mode            = "Install"
    },
    @{
        Name            = "PowerPoint"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Microsoft Office\root\Office16\powerpnt.exe"
        WorkingDir      = "C:\Program Files (x86)\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files (x86)\Microsoft Office\root\Office16\powerpnt.exe, 0"
        Description     = "PowerPoint 2016"
        Mode            = "Install"
    },
    @{
        Name            = "NRK Super"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://nrksuper.no/"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\ICO\nrk_super.ico"
        Description     = "NRK Super TV"
        Mode            = "Install"
    },
    @{
        Name            = "YouTube"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://www.youtube.com/"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Windows\ICO\youtube.ico"
        Description     = "YouTube"
        Mode            = "Install"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default