{ pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pc-1";
  # iwd only handles wifi auth, dhcpcd (NixOS default) still assigns addresses
  networking.wireless.iwd.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;

  programs.niri.enable = true;
  # niri has no font option, its UI text is hardcoded to "sans 14px"; --replace-fail flags upstream changes on bump
  programs.niri.package = pkgs.niri.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/ui/{config_error_notification,exit_confirm_dialog,hotkey_overlay,mru,screenshot_ui}.rs \
        --replace-fail '"sans 14px"' '"Iosevka Extended 14px"'
    '';
  });
  # chromium/electron wrappers in nixpkgs switch to native Wayland when this is set
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Google as default search; recommended (not managed) so it stays changeable in settings
  programs.chromium = {
    enable = true;
    extraOptsRecommended = {
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?output=chrome&q={searchTerms}";
    };
  };

  home-manager.users.${username} = {
    imports = [ ./home.nix ];
    programs.chromium = {
      package = pkgs.ungoogled-chromium;
      # force Wayland: NIXOS_OZONE_WL doesn't reach chromium in every launch path
      # and the X11 fallback fails, niri doesn't provide an X server
      commandLineArgs = [ "--ozone-platform=wayland" ];
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
