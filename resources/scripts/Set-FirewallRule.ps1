$profiles = Get-ChildItem -Path "C:\Users" -Directory

foreach ($profile in $profiles) {
    if (Test-Path (Join-Path -Path $profile.Fullname -ChildPath "AppData\Local\Microsoft\Teams\current\teams.exe")) {
        $firewallRuleName = "Teams.exe - $($profile.Name)"
        $ruleExist = Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue
        if ($ruleExist) {
            Set-NetFirewallRule -DisplayName $firewallRuleName -Profile Any -Action Allow
        }
        else {
            New-NetfirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol TCP -Profile Any -Program $TeamsDir -Action Allow
            New-NetfirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol UDP -Profile Any -Program $TeamsDir -Action Allow
        }
    }
}