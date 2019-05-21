$Printers = Get-Printer
$PrintersToRm = @('Rom 204 HOVOS', 'Rom 203 HOVOS', 'Rom 121 HOVOS', 'Rom 120 HOVOS')

Foreach ($Printer in $PrintersToRm) {
    If ($Printers.Name -contains $Printer.Name) {
        Remove-Printer -Name $Printer.Name
        Remove-PrinterPort -Name $Printer.Name
    }
}