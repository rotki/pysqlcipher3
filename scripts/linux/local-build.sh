#!/usr/bin/env bash

BUILD_DIR=$PWD

if [[ ! -d /tmp/.venv-ci ]]; then
  cd /tmp || exit 1
  pip install virtualenv --user
  echo creating virtualenv
  python -m virtualenv .venv-ci
fi

echo activating venv-ci
source /tmp/.venv-ci/bin/activate
pip install cibuildwheel==2.6.1

export CIBW_BEFORE_BUILD='./build.sh'
export CIBW_BUILD='cp39-*'
export CIBW_SKIP='*-musllinux_*'
export CIBW_ARCHS='native'
export CIBW_BUILD_VERBOSITY=1

cd $BUILD_DIR/build || exit 1

python -m cibuildwheel --output-dir wheelhouse --platform linux