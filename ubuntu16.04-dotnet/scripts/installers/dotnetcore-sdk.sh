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

wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

dpkg -i packages-microsoft-prod.deb

apt-get install apt-transport-https

apt-get update

apt-get install dotnet-sdk-2.1=2.1.301-1

# Get list of all released SDKs
release_url="https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"
releases=$(curl "${release_url}")
sdks=$(echo "${releases}" | grep version-sdk | grep -v preview | grep -v rc | grep -v display | cut -d\" -f4 | sort -u)
for sdk in $sdks; do
    # Glob matches dotnet-dev-1.x or dotnet-sdk-2.y
    if ! apt-get install -y --no-install-recommends "dotnet-*-$sdk"; then
        # Install manually if not in package repo
        if [[ "$sdk" =~ ^1.*$ ]]; then
            url="https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$sdk/dotnet-dev-ubuntu.16.04-x64.$sdk.tar.gz"
        else
            url="https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$sdk/dotnet-sdk-$sdk-linux-x64.tar.gz"
        fi
        echo "$url" >> urls
        echo "Adding $url to list to download later"
    fi
done

# Download additional SDKs
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

# Smoke test each SDK
for sdk in $sdks; do
    mksamples "$sdk" "console"
    mksamples "$sdk" "mstest"
    mksamples "$sdk" "xunit"
    mksamples "$sdk" "web"
    mksamples "$sdk" "mvc"
    mksamples "$sdk" "webapi"
    DocumentInstalledItem ".NET Core SDK $sdk"
done

# NuGetFallbackFolder at /usr/share/dotnet/sdk/NuGetFallbackFolder is warmed up by smoke test
# Additional FTE will just copy to ~/.dotnet/NuGet which provides no benefit on a fungible machine
echo "DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1" | tee -a /etc/environment
echo "PATH=\"/home/vsts/.dotnet/tools:$PATH\"" | tee -a /etc/environment

dotnet --info
