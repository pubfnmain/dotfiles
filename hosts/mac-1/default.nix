{ username, ... }: {
  # users.users.*.shell needs knownUsers, which nix-darwin says not to use for admin users
  system.activationScripts.postActivation.text = ''
    dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
  '';

  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager.users.${username}.imports = [ ../../home/darwin.nix ];
}
