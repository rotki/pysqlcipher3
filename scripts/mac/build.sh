#!/usr/bin/env bash

WORKDIR=$PWD
ARCH_POSTFIX=${CIBW_ARCHS_MACOS}

echo "Copying OpenSSL ${ARCH_POSTFIX} to openssl/"
cp -R "openssl-macos-$ARCH_POSTFIX" openssl/ || exit 1

cd "sqlcipher" || exit 1

echo "Creating SQLCipher amalgamation"

./configure \
  --enable-tempstore=yes \
  --disable-shared \
  --enable-static=yes \
  --with-crypto-lib=none \
  CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -I$WORKDIR/openssl/include" \
  LDFLAGS="$WORKDIR/openssl/lib/libcrypto.a" > /dev/null || exit 1

make sqlite3.c > /dev/null || exit 1

if [[ ! -d "$WORKDIR/amalgamation" ]]; then
  mkdir -p "$WORKDIR/amalgamation"
fi

cp sqlite3.c "$WORKDIR/amalgamation"
cp sqlite3.h "$WORKDIR/amalgamation"

if [[ ! -d "$WORKDIR/include" ]]; then
  mkdir -p "$WORKDIR/include/sqlcipher"
fi

cp sqlite3.h "$WORKDIR/include/sqlcipher"
