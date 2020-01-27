#!/bin/bash

VERSION=$1

echo "[*] Installing Python $VERSION";

source $HELPER_SCRIPTS/document.sh

PYTHONFOLDER=$AGENT_TOOLSDIRECTORY/Python/$VERSION/x64

cd /tmp/
wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz
tar -xf Python-$VERSION.tar.xz
cd Python-$VERSION
./configure --prefix=$PYTHONFOLDER

make -j`nproc`
make altinstall
touch $AGENT_TOOLSDIRECTORY/Python/$VERSION/x64.complete

cd ..

rm Python-$VERSION.tar.xz
rm -rf Python-$VERSION

# create symlinks
cd $AGENT_TOOLSDIRECTORY/Python/$VERSION/x64/bin
ln -s $(find -name 'python*' ! -name '*config' ! -name '*m') python
ln -s pip* pip
cd /azp/

echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Python $VERSION"
