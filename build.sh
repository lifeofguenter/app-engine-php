#!/usr/bin/env bash

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$(python -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

# required libs
source "${__DIR__}/.bash/functions.lib.sh"

set -E
trap 'throw_exception' ERR

extra_args=()

if [[ ! -z "${http_proxy}" ]]; then
  extra_args+=( "--build-arg" )
  extra_args+=( "http_proxy=${http_proxy}" )
fi

for dockerfile in tags/*/Dockerfile; do
  folder="${dockerfile%/*}"
  tag="${folder##*/}"

  consolelog "building ${tag}..."
  { docker build \
    --pull \
    -t "${DOCKER_REPO}:${tag}" \
    -f "${dockerfile}" \
    "${extra_args[@]}" \
    . 2> /dev/stdout \
    | while IFS= read -r line; do printf '[%s] %s\n' "${tag}" "${line}"; done; echo "${PIPESTATUS[0]}" > ".pid_${tag}"; } &
done
wait

for pid in .pid_*; do
  if [[ -f "${pid}" ]] && [[ "$(cat "${pid}")" != "0" ]]; then
    consolelog "${pid} failed!" "error"
    failed="1"
  fi
done
if [[ ! -z "${failed}" ]]; then
  exit 1
fi
