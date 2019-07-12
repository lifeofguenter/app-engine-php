#!/usr/bin/env bash

set -e

exec dev_appserver.py \
  --host 0.0.0.0 \
  --admin_host 0.0.0.0 \
  --storage_path /storage \
  --php_executable_path=/usr/bin/php-cgi \
  --php_gae_extension_path=/usr/lib/php/extensions/no-debug-non-zts-20121212/gae_runtime_module.so \
  "${@}"
