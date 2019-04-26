$Printers = Get-Printer
$PrintersToRm = @('2FL02588','2FL07038','QLC31644','XVC08019','XVF14345','QNW11407')

Foreach ($Printer in $PrintersToRm) {
    If ($Printers.Name -contains $Printer.Name) {
    Write-Host "remove $Printer.Name"
    }
}