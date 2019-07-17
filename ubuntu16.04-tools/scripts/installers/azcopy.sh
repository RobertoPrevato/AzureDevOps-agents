# Install AzCopy                                                               \
                                                                               \
                                                                                
                                                                                
if [ -f "/packages/azcopy.tar.gz" ]; then 
    echo "Using pre-fetched azcopy.tar.gz"
    cp /packages/azcopy.tar.gz .
else
    echo "Downloading azcopy.tar.gz"
    wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64
fi

tar -xf azcopy.tar.gz
rm azcopy.tar.gz
./install.sh

# Run tests to determine that the software installed as expected               \
                                                                               \
                                                                                
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! command -v azcopy; then
    echo "azcopy was not installed"
    exit 1
fi

rm -rf azcopy
rm install.sh