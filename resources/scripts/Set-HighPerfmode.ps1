## This script configures the registry keys required to enable the "High Performance" power plan in the Windows 11 Settings app. To ensure this works correctly, the "Balanced" power plan must first be selected in the "Legacy" Control Panel.

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes"
$Properties = @(
    @{ Name = "ActiveOverlayDcPowerScheme"; Value = "ded574b5-45a0-4f42-8737-46345c09c238" },
    @{ Name = "ActiveOverlayAcPowerScheme"; Value = "ded574b5-45a0-4f42-8737-46345c09c238" }
)

foreach ($Property in $Properties) {
    if (-not (Get-ItemProperty -Path $RegistryPath -Name $Property.Name -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $RegistryPath -Name $Property.Name -Value $Property.Value
        Write-Host "Registry key '$($Property.Name)' added with value '$($Property.Value)' in path '$RegistryPath'."
    } else {
        Write-Host "Registry key '$($Property.Name)' already exists."
    }
}
