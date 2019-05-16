#INITIATE FUNCTIONS AND VARIABLES
function Add-LPRPrinter {
    Param(
        $Server,
        $PrinterName,
        $Driver
    )
    Add-PrinterPort -PrinterName $PrinterName -HostName $Server -ErrorAction SilentlyContinue
    Add-Printer -DriverName $Driver -PortName ($Server + ":" + $PrinterName) -Name $PrinterName
}

$Username = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty Username
$Username = $Username.Replace("SKOLE\", "")

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

$Printers = @(
    @{
        Name   = "2FL02588"
        School = "Borre"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    },
    @{
        Name   = "2FL07038"
        School = "Borre"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    },
    @{
        Name   = "QLC31644"
        School = "Holtan"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    },
    @{
        Name   = "XVC08019"
        School = "Holtan"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    },
    @{
        Name   = "XVF14345"
        School = "Oreronningen"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    },
    @{
        Name   = "QNW11407"
        School = "Oreronningen"
        Server = "10.85.207.8"
        Driver = "Canon Generic Plus UFR II"
    }
)

#INITIATE INTIAL CLEAN UP CREW
foreach ($Printer in $Printers) {
    Invoke-Command -Scriptblock { RUNDLL32 PRINTUI.DLL, PrintUIEntry /gd /n\\$($Printer.Server+"\"+$Printer.Name) /q }
}

#INITIATE PRINTINSTALLS
if ($holtan -contains $Username) {
    $Printer = $Printers | Where-Object { $_.School -eq 'Holtan' }
    foreach ($p in $Printer) {
        Add-LPRPrinter -Server $p.Server -PrinterName $p.Name -Driver $p.Driver
    }
}

elseif ($borre -contains $Username) {
    $Printer = $Printers | Where-Object { $_.School -eq 'Borre' }
    foreach ($p in $Printer) {
        Add-LPRPrinter -Server $p.Server -PrinterName $p.Name -Driver $p.Driver
    }
}

elseif ($oreronningen -contains $Username) {
    $Printer = $Printers | Where-Object { $_.School -eq 'Oreronningen' }
    foreach ($p in $Printer) {
        Add-LPRPrinter -Server $p.Server -PrinterName $p.Name -Driver $p.Driver
    }
}

Restart-Service Spooler