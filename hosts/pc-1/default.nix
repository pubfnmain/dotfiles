{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pc-1";
  # iwd only handles wifi auth, dhcpcd (NixOS default) still assigns addresses
  networking.wireless.iwd.enable = true;

  programs.niri.enable = true;
  # chromium/electron wrappers in nixpkgs switch to native Wayland when this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.users.${username} = {
    imports = [ ./home.nix ];
    programs.chromium = {
      package = pkgs.ungoogled-chromium;
      # bake in what NIXOS_OZONE_WL adds, it doesn't reach chromium in every launch path
      # and without it chromium falls back to X11, which niri doesn't provide
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=WaylandWindowDecorations"
        "--enable-wayland-ime=true"
      ];
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    # wheel also grants iwctl access via iwd's D-Bus policy
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "x86_64-linux";
}
