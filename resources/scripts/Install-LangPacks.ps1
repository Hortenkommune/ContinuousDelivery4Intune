$LanguagesToInstall = "en-US", "en-GB"

foreach ($language in $LanguagesToInstall) {
    Get-WindowsCapability -Online | Where-Object Name -ilike "Language.*~~~$($language)~*" | ForEach-Object {
        if ($_.State -ine "Installed") {
            $_ | Add-WindowsCapability -Online | Out-Null
        }
    }
}