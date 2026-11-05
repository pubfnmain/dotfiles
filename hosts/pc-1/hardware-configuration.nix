# placeholder so the flake evaluates; replace with
# `nixos-generate-config --show-hardware-config` output from pc-1
{ lib, ... }: {
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/boot"; fsType = "vfat"; };

  networking.useDHCP = lib.mkDefault true;
}
