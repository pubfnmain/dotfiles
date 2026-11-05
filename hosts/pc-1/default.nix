{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pc-1";
  # iwd only handles wifi auth, dhcpcd (NixOS default) still assigns addresses
  networking.wireless.iwd.enable = true;

  programs.niri.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    # wheel also grants iwctl access via iwd's D-Bus policy
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
