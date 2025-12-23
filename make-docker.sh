#!/bin/bash

set -eEux -o pipefail

root="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")" && cd -- "${root}"

docker build --pull --no-cache --tag oils-for-unix-static .
