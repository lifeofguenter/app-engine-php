#!/usr/bin/env bash

set -e

version_varname="PHP_EXT_${1^^}_VERSION"

curl -fLO "http://pecl.php.net/get/${1}-${!version_varname}.tgz"
tar xf "${1}-${!version_varname}.tgz"
cd "${1}-${!version_varname}"
phpize
./configure
make -j"$(nproc)"
make install
cd ..
rm -rf "${1}-${!version_varname}"*
