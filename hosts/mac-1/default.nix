{ username, ... }: {
  # users.users.*.shell needs knownUsers, which nix-darwin says not to use for admin users
  system.activationScripts.postActivation.text = ''
    dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
  '';

  system.primaryUser = username;

  services.tailscale.enable = true;
  services.openssh.enable = true;

  # applies after logout/login
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;

  # Google as default search; unforced user defaults load as recommended policy, changeable in settings
  system.defaults.CustomUserPreferences."org.chromium.Chromium" = {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://www.google.com/complete/search?output=chrome&q={searchTerms}";
  };
  # apps missing from nixpkgs; nix-darwin drives brew but Homebrew itself is installed by hand
  homebrew = {
    enable = true;
    # telegram is the native macOS client, not the Qt telegram-desktop pc-1 gets from nixpkgs
    casks = [ "affinity" "telegram" "ungoogled-chromium" ];
  };

  users.users.${username}.home = "/Users/${username}";

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager.users.${username}.imports = [ ../../home/darwin.nix ];
}
