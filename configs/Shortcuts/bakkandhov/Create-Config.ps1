$Shortcuts = @(
    @{
        Name            = "Microsoft OneDrive"
        Type            = "lnk"
        Path            = "C:\Windows\explorer.exe"
        Arguments       = "microsoft-edge:`"https://hortenkommune365-my.sharepoint.com/`""
        WorkingDir      = ""
        IconFileandType = "C:\Windows\ICO\Onedrive.ico"
        Description     = "Microsoft OneDrive"
    }
)

$Shortcuts | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default