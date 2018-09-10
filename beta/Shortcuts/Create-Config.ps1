$Shortcuts = @(
    @{
        Name            = "Google Earth"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://earth.google.com/web"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe, 0"
        Description     = "Google Earth Cloud"
        Mode            = "Install"
    },
    @{
        Name            = "Office 365"
        Type            = "lnk"
        Path            = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        Arguments       = "https://adfs.horten.kommune.no/adfs/ls/?wa=wsignin1.0&wtrealm=urn:federation:MicrosoftOnline&wctx=wa%3Dwsignin1.0%26rpsnv%3D3%26ver%3D6.4.6456.0%26wp%3DMCMBI%26wreply%3Dhttps:%252F%252Fportal.office.com%252Flanding.aspx%253Ftarget%253D%25252fHome&RedirectToIdentityProvider=http%3a%2f%2fadfs.horten.kommune.no%2fadfs%2fservices%2ftrust"
        WorkingDir      = "C:\Program Files (x86)\Google\Chrome\Application"
        IconFileandType = "C:\Program Files (x86)\Microsoft Office\root\Office16\protocolhandler.exe, 0"
        Description     = "Office 365"
        Mode            = "Install"
    },
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
        Name            = "Printkode"
        Type            = "lnk"
        Path            = "C:\Program Files\internet explorer\iexplore.exe"
        Arguments       = "http://10.82.24.82/kode"
        WorkingDir      = "C:\Program Files\internet explorer\"
        IconFileandType = "C:\Program Files\internet explorer\iexplore.exe, 0"
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
    },
    @{
        Name            = "Print Kode"
        Type            = "lnk"
        Path            = "DUMMY"
        Arguments       = "DUMMY"
        WorkingDir      = "DUMMY"
        IconFileandType = "DUMMY"
        Description     = "DUMMY"
        Mode            = "Uninstall"
    },
    @{
        Name            = "GIMP 2"
        Type            = "lnk"
        Path            = "DUMMY"
        Arguments       = "DUMMY"
        WorkingDir      = "DUMMY"
        IconFileandType = "DUMMY"
        Description     = "DUMMY"
        Mode            = "Uninstall"
    },
    @{
        Name            = "GIMP 2.10"
        Type            = "lnk"
        Path            = "DUMMY"
        Arguments       = "DUMMY"
        WorkingDir      = "DUMMY"
        IconFileandType = "DUMMY"
        Description     = "DUMMY"
        Mode            = "Uninstall"
    }
)
$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default