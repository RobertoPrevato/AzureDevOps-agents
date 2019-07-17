
echo '[*] Installing Python 3.7'

PYTHON373FOLDER=$TOOLSFOLDER/Python/3.7.3/x64

apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    wget && \

    cd /tmp/ && \
    wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz && \
    tar -xf Python-3.7.3.tar.xz && \
    cd Python-3.7.3 && \
    ./configure --prefix=$PYTHON373FOLDER &&  # --enable-optimizations ??? TODO: choose

    make -j`nproc` &&
    make altinstall &&
    touch $TOOLSFOLDER/Python/3.7.3/x64.complete

cd ..

rm Python-3.7.3.tar.xz
rm -rf Python-3.7.3
