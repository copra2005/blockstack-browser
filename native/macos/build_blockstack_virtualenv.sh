#!/bin/bash

# Script build the blockstack virtualenv distributed with
# the macOS app


## make working directory the same as location of script
#cd "$(dirname "$0")"

# Make build script exit if any command returns error code.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

echo "Script is running in $SCRIPT_DIR"

cd /tmp

echo "Removing any existing virtualenv dir..."

rm -Rfv blockstack-venv

echo "Creating a new virtualenv..."

virtualenv -p $(which python2.7) blockstack-venv

echo "Updating virtualenv pip to latest version..."                                                                                                                               
pip install --upgrade pip

echo "Activating virtualenv..."

source blockstack-venv/bin/activate

echo "Install cryptography, making sure we get the universal binary"
pip install cryptography --only-binary cryptography

echo "Build statically-linked scrypt..."
PYSCRYPT_NO_LINK_FLAGS="1" LDFLAGS="/usr/local/opt/openssl/lib/libcrypto.a /usr/local/opt/openssl/lib/libssl.a" CFLAGS="-I/usr/local/opt/openssl/include" pip install git+https://github.com/larrysalibra/py-scrypt --no-use-wheel


echo "Installing blockstack..."

pip install --upgrade git+https://github.com/blockstack/blockstack-core.git@ef19dd44e7da977f4b4567eff52845b1758f7eb9

echo "Blockstack virtual environment created."

echo "Making Blockstack virtual environment relocatable..."

cd /tmp/

virtualenv --relocatable blockstack-venv

echo "Build Blockstack virtualenv archive..."

tar -czvf $SCRIPT_DIR/Blockstack/Blockstack/blockstack-venv.tar.gz blockstack-venv
