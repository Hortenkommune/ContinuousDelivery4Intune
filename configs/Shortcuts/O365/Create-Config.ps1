$Shortcuts = @(
    @{
        Name            = "Word"
        Type            = "lnk"
        Path            = "C:\Program Files\Microsoft Office\root\Office16\winword.exe"
        WorkingDir      = "C:\Program Files\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files\Microsoft Office\root\Office16\winword.exe, 0"
        Description     = "Word"
    },
    @{
        Name            = "Excel"
        Type            = "lnk"
        Path            = "C:\Program Files\Microsoft Office\root\Office16\excel.exe"
        WorkingDir      = "C:\Program Files\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files\Microsoft Office\root\Office16\excel.exe, 0"
        Description     = "Excel"
    },
    @{
        Name            = "PowerPoint"
        Type            = "lnk"
        Path            = "C:\Program Files\Microsoft Office\root\Office16\powerpnt.exe"
        WorkingDir      = "C:\Program Files\Microsoft Office\root\Office16\"
        IconFileandType = "C:\Program Files\Microsoft Office\root\Office16\powerpnt.exe, 0"
        Description     = "PowerPoint"
    },
    @{
        Name            = "Office 365"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://portal.office.com`""
        WorkingDir      = ""
        IconFileandType = "C:\Program Files\Microsoft Office\root\Office16\protocolhandler.exe, 0"
        Description     = "Office 365"
    }
)

$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default