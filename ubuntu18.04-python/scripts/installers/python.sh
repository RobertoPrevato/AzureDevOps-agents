#!/bin/bash
################################################################################
##  File:  python.sh
##  Team:  CI-Platform
##  Desc:  Installs Python 3 and related tools (pip, pypy)
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh

# Install Python 3, pip3
apt-get install -y --no-install-recommends python3 python3-dev python3-pip

# Install PyPy 3.6 to $AGENT_TOOLSDIRECTORY
wget -q -P /tmp https://downloads.python.org/pypy/pypy3.6-v7.3.1-linux64.tar.bz2
tar -x -C /tmp -f /tmp/pypy3.6-v7.3.1-linux64.tar.bz2
rm /tmp/pypy3.6-v7.3.1-linux64.tar.bz2
mkdir -p $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7
mv /tmp/pypy3.6-v7.3.1-linux64 $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64
touch $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64.complete

# add pypy3 to PATH by default
ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/pypy3 /usr/local/bin/pypy3
# pypy3 will be the python in PATH when its tools cache directory is prepended to PATH
# PEP 394-style symlinking; don't bother with minor version
ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/pypy3 $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/python3
ln -s $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/python3 $AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/python

# Install latest Pip for PyPy3
$AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/pypy3 -m ensurepip
$AGENT_TOOLSDIRECTORY/PyPy/3.6-v7/x64/bin/pypy3 -m pip install --ignore-installed pip

# Run tests to determine that the software installed as expected
# python pypy
echo "Testing to make sure that script performed as expected, and basic scenarios work"
for cmd in python3 pypy3; do
    if ! command -v $cmd; then
        echo "$cmd was not installed or not found on PATH"
        exit 1
    fi
done

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Python3 ($(python3 --version))"
DocumentInstalledItem "pip3 ($(pip3 --version))"
DocumentInstalledItem "PyPy3 ($(pypy3 --version 2>&1 | grep PyPy))"
