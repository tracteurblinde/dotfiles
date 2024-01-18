#!/usr/bin/env bash
set -e -u -o pipefail

PWD="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR"
nix flake update

cd "$PWD"
