#!/bin/bash
################################################################################
##  File:  azcopy.sh
##  Team:  CI-Platform
##  Desc:  Installs AzCopy
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh

if [ -f "/packages/azcopy.tar.gz" ]; then
    echo "Using pre-fetched azcopy.tar.gz"
    cp /packages/azcopy.tar.gz .
else
    echo "Downloading azcopy.tar.gz"
    wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64
fi

# Install AzCopy
tar -xf azcopy.tar.gz
rm azcopy.tar.gz
./install.sh

rm install.sh

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! command -v azcopy; then
    echo "azcopy was not installed"
    exit 1
fi

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "AzCopy ($(azcopy --version))"
