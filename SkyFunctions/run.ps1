$functions = Invoke-RestMethod "https://raw.githubusercontent.com/Hortenkommune/ContinuousDelivery4Intune/SkyFunctions/SkyFunctions/config.json" -UseBasicParsing


$SB = [scriptblock]::Create($Function)