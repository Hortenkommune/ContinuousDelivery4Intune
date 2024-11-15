## This script configures the registry keys required to enable the "High Performance" power plan in the Windows 11 Settings app. To ensure this works correctly, the "Balanced" power plan must first be selected in the "Legacy" Control Panel.

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes"
$Properties = @(
    @{ Name = "ActiveOverlayDcPowerScheme"; Value = "ded574b5-45a0-4f42-8737-46345c09c238" },
    @{ Name = "ActiveOverlayAcPowerScheme"; Value = "ded574b5-45a0-4f42-8737-46345c09c238" }
)


foreach ($Property in $Properties) {
    try {
        $CurrentValue = Get-ItemProperty -Path $RegistryPath -Name $Property.Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $($Property.Name)
        
        if ($CurrentValue -ne $Property.Value) {
            Set-ItemProperty -Path $RegistryPath -Name $Property.Name -Value $Property.Value
            Write-Host "Registry key '$($Property.Name)' updated with value '$($Property.Value)' in path '$RegistryPath'."
        } else {
            Write-Host "Registry key '$($Property.Name)' already has the correct value."
        }
    } catch {
        Set-ItemProperty -Path $RegistryPath -Name $Property.Name -Value $Property.Value
        Write-Host "Registry key '$($Property.Name)' added with value '$($Property.Value)' in path '$RegistryPath'."
    }
}
