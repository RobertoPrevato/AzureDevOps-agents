#!/bin/bash
################################################################################
##  File:  dotnetcore-sdk.sh
##  Team:  CI-Platform
##  Desc:  Installs .NET Core SDK
################################################################################

source $HELPER_SCRIPTS/apt.sh
source $HELPER_SCRIPTS/document.sh

mksamples()
{
    sdk=$1
    sample=$2
    mkdir "$sdk"
    cd "$sdk" || exit
    set -e
    dotnet help
    dotnet new globaljson --sdk-version "$sdk"
    dotnet new "$sample"
    dotnet restore
    dotnet build
    set +e
    cd .. || exit
    rm -rf "$sdk"
}

set -e

apt-get install dotnet-sdk-2.1=2.1.301-1
apt-get install dotnet-sdk-2.2
apt-get install dotnet-sdk-3.1

#
# Uncomment the following lines to get a bigger list, dynamically;
#
# release_url="https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"
# releases=$(curl "${release_url}")
# sdks=$(echo "${releases}" | grep version-sdk | grep -v preview | grep -v rc | grep -v display | cut -d\" -f4 | sort -u | grep '^2')

sdks=(2.1.100 2.1.4 2.1.503 2.1.801 2.2.100 2.2.105 2.2.401)

for sdk in $sdks; do
    # Glob matches dotnet-dev-1.x or dotnet-sdk-2.y
    if ! apt-get install -y --no-install-recommends "dotnet-*-$sdk"; then
        # Install manually if not in package repo
        if [[ "$sdk" =~ ^1.*$ ]]; then
            # https://dotnet.microsoft.com/download/linux-package-manager/rhel/sdk-2.2.401
            url="https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$sdk/dotnet-dev-ubuntu.16.04-x64.$sdk.tar.gz"
        else
            url="https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$sdk/dotnet-sdk-$sdk-linux-x64.tar.gz"
        fi
        echo "$url" >> urls
        echo "Adding $url to list to download later"
    fi
done

# Download additional SDKs
if test -f "urls"; then
    echo "Downloading release tarballs..."
    sort -u urls | xargs -n 1 -P 16 wget -q
    for tarball in *.tar.gz; do
        dest="./tmp-$(basename -s .tar.gz $tarball)"
        echo "Extracting $tarball to $dest"
        mkdir "$dest" && tar -C "$dest" -xzf "$tarball"
        rsync -qav "$dest/shared/" /usr/share/dotnet/shared/
        rsync -qav "$dest/host/" /usr/share/dotnet/host/
        rsync -qav "$dest/sdk/" /usr/share/dotnet/sdk/
        rm -rf "$dest"
        rm "$tarball"
    done
    rm urls
fi

# NB: uncomment the following lines, to smoke test all installed sdks
for sdk in $sdks; do
    # mksamples "$sdk" "console"
    # mksamples "$sdk" "mstest"
    # mksamples "$sdk" "xunit"
    # mksamples "$sdk" "web"
    # mksamples "$sdk" "mvc"
    # mksamples "$sdk" "webapi"
    DocumentInstalledItem ".NET Core SDK $sdk"
done

# NuGetFallbackFolder at /usr/share/dotnet/sdk/NuGetFallbackFolder is warmed up by smoke test
# Additional FTE will just copy to ~/.dotnet/NuGet which provides no benefit on a fungible machine
echo "DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1" | tee -a /etc/environment
echo "PATH=\"/home/vsts/.dotnet/tools:$PATH\"" | tee -a /etc/environment

