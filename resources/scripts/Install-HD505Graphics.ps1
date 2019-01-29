Expand-Archive -Path "C:\Windows\Temp\vga6286.zip" -DestinationPath "C:\Windows\Temp\vga6286"
Start-Process -FilePath "C:\Windows\Temp\vga6286\igxpin.exe" -ArgumentList "-s" -Wait
Remove-Item -Path "C:\Windows\Temp\vga6286" -Recurse -Force