#!/bin/bash
################################################################################
##  File:  azpowershell.sh
##  Team:  CI-Platform
##  Desc:  Installed Azure PowerShell
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh

# Install Azure CLI (instructions taken from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
pwsh -Command 'Save-Module -Name Az -LiteralPath /usr/share/az_1.0.0 -RequiredVersion 1.0.0 -Force'
pwsh -Command 'Save-Module -Name Az -LiteralPath /usr/share/az_1.6.0 -RequiredVersion 1.6.0 -Force'

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! pwsh -Command '$actualPSModulePath = $env:PSModulePath ; $env:PSModulePath = "/usr/share/az_1.0.0:" + $env:PSModulePath;
    if (!(get-module -listavailable -name Az.Accounts)) {
        Write-Host "Az Module was not installed"; $env:PSModulePath = $actualPSModulePath; exit 1
    }
    $env:PSModulePath = $actualPSModulePath
    $actualPSModulePath = $env:PSModulePath ; $env:PSModulePath = "/usr/share/az_1.6.0:" + $env:PSModulePath;
    if (!(get-module -listavailable -name Az.Accounts)) {
        Write-Host "Az Module was not installed"; $env:PSModulePath = $actualPSModulePath; exit 1
    }
    $env:PSModulePath = $actualPSModulePath'; then
    exit 1
fi

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Az Module (1.0.0)"
DocumentInstalledItem "Az Module (1.6.0)"