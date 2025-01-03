﻿$ChocoPkgs = @(
    # @{
    #     Name = "googlechrome"
    #     Mode = "uninstall"
    # },
    # @{
    #     Name = "microsoft-teams.install"
    #     Mode = "install"
    # },
    # @{
    #     Name = "audacity --version=3.0.0"
    #     Mode = "uninstall"
    # },
    # @{
    #     Name = "audacity --version=3.0.1"
    #     Mode = "uninstall"
    # },
    # @{
    #     Name = "audacity --version=3.0.2"
    #     Mode = "uninstall"
    # },
    # @{
    #     Name = "audacity --version=3.0.3"
    #     Mode = "uninstall"
    # },
    # @{
    #     Name = "audacity --version=2.4.2 --allow-downgrade"
    #     Mode = "install"
    # },
    # @{
    #     Name = "sccmtoolkit"
    #     Mode = "install"
    # },
    # @{
    #     Name = "dotnet3.5"
    #     Mode = "install"
    # },
    # @{
    #     Name = "devcon.portable"
    #     Mode = "install"
    # },
    # @{
    #     Name = "dotnet"
    #     Mode = "install"
    # }
)
$ChocoPkgs | ConvertTo-Json -Compress | Out-File "$PSScriptRoot\config.json" -Encoding default