$PowerCFG = "powercfg.exe"

Start-Process -FilePath $PowerCFG -ArgumentList '/SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_PROCESSOR PROCTHROTTLEMIN 100' -Wait