$PowerCFG = "powercfg.exe"

Start-Process -FilePath $PowerCFG -ArgumentList '/s 381b4222-f694-41f0-9685-ff5bb260df2e' -Wait

Start-Process -FilePath $PowerCFG -ArgumentList '/SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 1' -Wait

Start-Process -FilePath $PowerCFG -ArgumentList '/SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 1' -Wait

Start-Process -FilePath $PowerCFG -ArgumentList '-h off' -Wait