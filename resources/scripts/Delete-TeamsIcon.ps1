$Desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $Desktop "Microsoft Teams (work or school).lnk"

# Check if the shortcut exists before attempting to delete
if (Test-Path $shortcutPath) {
    Remove-Item -Path $shortcutPath -Force
    Write-Host "Shortcut '$shortcutPath' deleted successfully."
} else {
    Write-Host "Shortcut '$shortcutPath' not found."
}
