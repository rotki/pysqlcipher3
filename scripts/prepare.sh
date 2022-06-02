#!/usr/bin/env bash

SOURCE_DIR=$PWD
BUILD_DIR="$SOURCE_DIR/build"

SQLCIPHER_DIR="$SOURCE_DIR/sqlcipher"
PYSQLCIPHER_DIR="$SOURCE_DIR/pysqlcipher3"

BUILD_OS=$(uname -s)

if [[ $BUILD_OS == 'Linux' ]]; then
  BUILD_PLATFORM='linux'
else
  BUILD_PLATFORM='mac'
fi

if [[ -d "$BUILD_DIR" ]]; then
  echo "$BUILD_DIR already exists, cleaning up"
  rm -rf $BUILD_DIR
fi

echo "Preparing pysqlcipher3 setup patch"

cd "$SOURCE_DIR/patches" || exit 1
pip install -r requirements.txt
./patch-gen.py --platform "$BUILD_PLATFORM"


cd "$PYSQLCIPHER_DIR" || exit 1
git reset --hard HEAD
echo "Patching Readme/License/Manifest"
git apply --reject --whitespace=fix "$SOURCE_DIR/patches/pysqlcipher3.patch"
echo "Patching setup.py"
git apply --reject --whitespace=fix "$SOURCE_DIR/patches/pysqlcipher3.diff"
echo "Copying pysqlcipher3"
cp -R "$PYSQLCIPHER_DIR" "$BUILD_DIR"
git reset --hard HEAD

echo "Copying SQLCipher to $BUILD_DIR"

cp -R "$SQLCIPHER_DIR" "$BUILD_DIR/"

echo "Copying $BUILD_PLATFORM/build.sh"

cp "$SOURCE_DIR/scripts/$BUILD_PLATFORM/build.sh" "$BUILD_DIR"

if [[ $BUILD_OS == 'Linux' ]]; then
  echo "Copying OpenSSL to build dir"
  cp -R "$SOURCE_DIR/openssl" "$BUILD_DIR/"
fi

if [[ -d "$SOURCE_DIR/openssl-macos-arm64" ]]; then
  echo "Copying arm64 OpenSSL"
  cp -R "$SOURCE_DIR/openssl-macos-arm64" "$BUILD_DIR/"
fi

if [[ -d "$SOURCE_DIR/openssl-macos-universal2" ]]; then
  echo "Copying universal2 OpenSSL"
  cp -R "$SOURCE_DIR/openssl-macos-universal2" "$BUILD_DIR/"
fi

if [[ -d "$SOURCE_DIR/openssl-macos-x86_64" ]]; then
  echo "Copying x86_64 OpenSSL"
  cp -R "$SOURCE_DIR/openssl-macos-x86_64" "$BUILD_DIR/"
fi
