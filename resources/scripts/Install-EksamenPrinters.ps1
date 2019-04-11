$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username
$Username = $Username.Replace("SKOLE\", "")
$InstallPath = $env:PROGRAMFILES + "\HK-ELEV"
$PrinterDriverInf = "Cnp60MA64.INF"
$InstallDriverPath = $InstallPath + "\" + $PrinterDriverInf
$ZipFile = $env:windir + "\Temp\cnlb0m.zip"
$PrinterDriver = "Canon Generic Plus PCL6"

Expand-Archive -Path $ZipFile -DestinationPath $InstallPath -Force
Start-Process -FilePath "pnputil.exe" -ArgumentList "/Add-Driver `"$InstallDriverPath`"" -Wait
Add-PrinterDriver -Name $PrinterDriver

$Printers = @(
    @{
        Name     = "2FL02588"
        IP       = "10.82.102.39"
        School   = "Borre"
        Location = "Skole / Borre / Inspektør"
    },
    @{
        Name     = "2FL07038"
        IP       = "10.85.102.16"
        School   = "Borre"
        Location = "Skole / Borre / Bibliotek"
    },
    @{
        Name     = "QLC31644"
        IP       = "10.85.105.9"
        School   = "Holtan" 
        Location = "Skole / Holtan / Aktivitetsrom Elev"
    },
    @{
        Name     = "XVC08019"
        IP       = "10.82.105.22"
        School   = "Holtan"
        Location = "Skole / Holtan / rom A132"
    },
    @{
        Name     = "XVF14345"
        IP       = "10.82.111.6"
        School   = "Oreronningen"
        Location = "Skole / Orerønningen / Gang"
    },
    @{
        Name     = "QNW11407"
        IP       = "10.85.111.17"
        School   = "Oreronningen"
        Location = "Skole / Oreronningen / Rom 2033"
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
    $Printer = $Printers | Where-Object {$_.school -eq 'holtan'}
    foreach ($p in $Printer) {
        if (Get-Printer -Name $p.name -ErrorAction SilentlyContinue) {
            Set-Printer -Name $p.name -DriverName "Canon Generic Plus PCL6"
            Write-Host "$($p.name) Exist, Skipping"
        }
        else {
            Add-PrinterPort -PrinterHostAddress $p.IP -Name $p.name -ErrorAction SilentlyContinue
            Add-Printer -Name $p.name -PortName $p.Name -Location $p.Location -DriverName "Canon Generic Plus PCL6" 
        }
    }
}

if ($borre -contains $username) {
    $Printer = $Printers | Where-Object {$_.school -eq 'borre'} 
    foreach ($p in $Printer) {
        if (Get-Printer -Name $p.name -ErrorAction SilentlyContinue) {
            Set-Printer -Name $p.name -DriverName "Canon Generic Plus PCL6"
            Write-Host "$($p.name) Exist, Skipping"
        }
        else {
            Add-PrinterPort -PrinterHostAddress $p.IP -Name $p.name -ErrorAction SilentlyContinue
            Add-Printer -Name $p.name -PortName $p.Name -Location $p.Location -DriverName "Canon Generic Plus PCL6" 
        }
    }
}

if ($oreronningen -contains $username) {
    $Printer = $Printers | Where-Object {$_.school -eq 'oreronningen'} 
    foreach ($p in $Printer) {
        if (Get-Printer -Name $p.name -ErrorAction SilentlyContinue) {
            Set-Printer -Name $p.name -DriverName "Canon Generic Plus PCL6"
            Write-Host "$($p.name) Exist, Skipping"
        }
        else {
            Add-PrinterPort -PrinterHostAddress $p.IP -Name $p.name -ErrorAction SilentlyContinue
            Add-Printer -Name $p.name -PortName $p.Name -Location $p.Location -DriverName "Canon Generic Plus PCL6" 
        }
    }
}

#if ($Username -notlike '*eksamen*') {
#    $Printer = $Printers
#    foreach ($p in $Printer) {
#        Remove-Printer -Name $p.name
#        Remove-PrinterPort -Name $p.name 
#    }
#}