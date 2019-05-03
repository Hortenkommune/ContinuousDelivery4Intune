$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username
$Username = $Username.Replace("SKOLE\", "")
$InstalledPrinters = Get-Printer

$Printers = @(
    @{
        Name     = "2FL02588"
        School   = "Borre"
        Server   = "10.85.207.8"
    },
    @{
        Name     = "2FL07038"
        School   = "Borre"
        Server   = "10.85.207.8"
    },
    @{
        Name     = "QLC31644"
        School   = "Holtan"
        Server   = "10.85.207.8" 
    },
    @{
        Name     = "XVC08019"
        School   = "Holtan"
        Server   = "10.85.207.8"
    },
    @{
        Name     = "XVF14345"
        School   = "Oreronningen"
        Server   = "10.85.207.8"
    },
    @{
        Name     = "QNW11407"
        School   = "Oreronningen"
        Server   = "10.85.207.8"
    }
)
 
$holtan = @()
@(001..199) | ForEach-Object {
    $_ = $_.ToString("000")
    $holtan += "eksamen" + $_
}
$borre = @()
@(200..399) | ForEach-Object {
    $_ = $_.ToString("000")
    $borre += "eksamen" + $_
}
$oreronningen = @()
@(400..599) | ForEach-Object {
    $_ = $_.ToString("000")
    $oreronningen += "eksamen" + $_
}
 
if ($holtan -contains $username) {
    $Printer = $Printers | Where-Object { $_.school -eq 'holtan' }
    foreach ($p in $Printer) {
        if (!($InstalledPrinters.Name -contains $p.Name)) {
            Invoke-Command -Scriptblock { RUNDLL32 PRINTUI.DLL, PrintUIEntry /ga /n\\$($P.Server+"\"+$P.Name) /q }
        }
    }
}

elseif ($borre -contains $username) {
    $Printer = $Printers | Where-Object { $_.school -eq 'borre' } 
    foreach ($p in $Printer) {
        if (!($InstalledPrinters.Name -contains $p.Name)) {
            Invoke-Command -Scriptblock { RUNDLL32 PRINTUI.DLL, PrintUIEntry /ga /n\\$($P.Server+"\"+$P.Name) /q }
        }
    }
}

elseif ($oreronningen -contains $username) {
    $Printer = $Printers | Where-Object { $_.school -eq 'oreronningen' } 
    foreach ($p in $Printer) {
        if (!($InstalledPrinters.Name -contains $p.Name)) {
            Invoke-Command -Scriptblock { RUNDLL32 PRINTUI.DLL, PrintUIEntry /ga /n\\$($P.Server+"\"+$P.Name) /q }
        }
    }
}

else {
    $Printer = $Printers
    foreach ($p in $Printer) {
        Invoke-Command -Scriptblock { RUNDLL32 PRINTUI.DLL, PrintUIEntry /gd /n\\$($P.Server+"\"+$P.Name) /q }
    }
}

#Restart-Service Spooler