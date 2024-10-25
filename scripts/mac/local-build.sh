#!/usr/bin/env bash

BUILD_DIR=$PWD

if [[ ! -d /tmp/.venv-ci ]]; then
  cd /tmp || exit 1
  pip3 install virtualenv --user
  echo creating virtualenv
  python -m virtualenv .venv-ci
fi

echo activating venv-ci
source /tmp/.venv-ci/bin/activate
pip3 install cibuildwheel==2.21.3

export CIBW_BEFORE_ALL='./build.sh'
export CIBW_BUILD='cp311-*'
export CIBW_SKIP='*-musllinux_*'
export CIBW_ARCHS='native'
export CIBW_BUILD_VERBOSITY=1

cd $BUILD_DIR/build || exit 1

python3 -m cibuildwheel --output-dir wheelhouse --platform macos