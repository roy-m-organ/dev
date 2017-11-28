#!/bin/bash
# ISC, Copyright 2017 Jaco Greeff

set -e

function build_js () {
  ROOT=$1

  echo ""
  echo "*** Cleaning build directory"

  yarn run rimraf $ROOT/build

  echo ""
  echo "*** Compiling via babel"

  yarn run babel --out-dir $ROOT/build --ignore '*.spec.js' $ROOT/src

  echo ""
  echo "*** Copying flow types (source)"

  yarn run flow-copy-source --verbose --ignore '*.spec.js' $ROOT/src $ROOT/build

  if [ -d "$ROOT/flow-typed" ]; then
    echo ""
    echo "*** Copying flow types (libraries)"

    cp -r $ROOT/flow-typed $ROOT/build
  fi

  echo ""
  echo "*** Build completed"
}

if [ -d "packages" ]; then
  PACKAGES=( $(ls -1d packages/*) )

  for PACKAGE in "${PACKAGES[@]}"; do
    echo ""
    echo "*** Executing in $PACKAGE"

    build_js "$PACKAGE"
  done
else
  build_js "."
fi

exit 0
