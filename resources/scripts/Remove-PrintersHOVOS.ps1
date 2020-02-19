$Printers = Get-Printer
$PrintersToRm = @('Rom 204 HOVOS', 'Rom 203 HOVOS', 'Rom 121 HOVOS', 'Rom 120 HOVOS')

Foreach ($Printer in $PrintersToRm) {
    If ($Printers.Name -contains $Printer) {
        Remove-Printer -Name $Printer
        Remove-PrinterPort -Name $Printer
    }
}