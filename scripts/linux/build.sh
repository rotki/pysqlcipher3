#!/usr/bin/env bash

WORKDIR=$PWD


if [[ -n "$(command -v yum)" ]]; then
  echo "Installing tcl using yum"
  yum -y install tcl-devel
fi

if [[ -n "$(command -v apt-get)" ]]; then
  echo "Installing tcl using apt"
  apt-get install tcl-dev
fi

echo "Preparing for arch $AUDITWHEEL_ARCH"

if [[ $AUDITWHEEL_ARCH == "x86_64" ]]; then
  OPENSSL_CONFIGURATION='linux-x86_64'
elif [[ $AUDITWHEEL_ARCH == "aarch64" ]]; then
  OPENSSL_CONFIGURATION='linux-aarch64'
else
  exit 1
fi

echo "🏗️ Building OpenSSL"
cd openssl || exit 1
./Configure $OPENSSL_CONFIGURATION no-shared no-asm no-idea no-camellia no-weak-ssl-ciphers \
  no-seed no-bf no-cast no-rc2 no-rc4 no-rc5 no-md2 \
  no-md4 no-ecdh no-sock no-ssl3 \
  no-dsa no-dh no-ec no-ecdsa no-tls1 \
  no-rfc3779 no-whirlpool no-srp \
  no-mdc2 no-ecdh no-engine no-srtp \
  --prefix=/usr/local/ssl --openssldir=/usr/local/ssl > /dev/null

make > /dev/null
make install_sw > /dev/null

echo "✔️ OpenSSL Build Complete"

echo "🏗️ Creating SQLCipher amalgamation"

cd "$WORKDIR/sqlcipher" || exit 1

./configure \
  --enable-tempstore=yes \
  --disable-shared \
  --enable-static=yes \
  --with-crypto-lib=none > /dev/null

make sqlite3.c > /dev/null

echo "✔️ SQLCipher amalgamation created"

echo "Moving amalgamation to $WORKDIR/amalgamation"

if [[ ! -d "$WORKDIR/amalgamation" ]]; then
  mkdir -p "$WORKDIR/amalgamation"
fi

cp sqlite3.c "$WORKDIR/amalgamation"
cp sqlite3.h "$WORKDIR/amalgamation"

echo "Preparing SQLCipher include directory"

if [[ ! -d "$WORKDIR/include" ]]; then
  mkdir -p "$WORKDIR/include/sqlcipher"
fi

cp sqlite3.h "$WORKDIR/include/sqlcipher"
