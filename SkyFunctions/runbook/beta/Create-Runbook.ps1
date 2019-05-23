$runbook = @{
    Name = "beta"
    Actions = @(
        @{
            Function = "Install-SC"
            Config = @(
                @{
                    cfguri = ""
                }
            )
        }
    )
}