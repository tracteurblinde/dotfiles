#!/usr/bin/env bash
set -e -u -o pipefail

sudo nixos-rebuild --refresh --upgrade switch
home-manager --refresh switch
