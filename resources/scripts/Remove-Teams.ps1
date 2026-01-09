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

if (!(Test-Path "C:\Windows\ico")) {
    New-Item -Path "C:\Windows\ico" -ItemType Directory
}

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/master/resources/ico/teams.ico" -OutFile "C:\Windows\ico\teams.ico" -UseBasicParsing