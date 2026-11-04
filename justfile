host := "mac-1"

default:
    @just --list

# build and activate system config
switch:
    sudo darwin-rebuild switch --flake .#{{host}}

# build without activating
build:
    darwin-rebuild build --flake .#{{host}}

# bump all flake inputs
update:
    nix flake update

check:
    nix flake check
