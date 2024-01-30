#!/usr/bin/env bash
set -e -u -o pipefail

sudo nixos-rebuild switch
home-manager switch
