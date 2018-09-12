$Folders = Get-ChildItem "C:\Users"

ForEach ($Folder in $Folders) {
    If (!(($Folder.Name -eq "defaultuser0") -or ($Folder.Name -eq "Public"))) {
        Start-Process -FilePath "$($Folder.FullName)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList '--uninstall -s' -Wait
        Remove-Item -Path "$($Folder.FullName)\Desktop\Microsoft Teams.lnk" -Force 
        Remove-Item -Path "$($Folder.FullName)\AppData\Local\Microsoft\Teams" -Recurse -Force 
        Remove-Item -Path "$($Folder.FullName)\AppData\Local\SquirrelTemp" -Recurse -Force
        Remove-Item -Path "$($Folder.FullName)\AppData\Roaming\Microsoft\Teams" -Recurse -Force 
        Remove-Item -Path "$($Folder.FullName)\Local\Microsoft\TeamsMeetingAddin" -Recurse -Force
    }
}