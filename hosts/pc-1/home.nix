# home-manager config for pc-1 only; ghostty itself comes from home/default.nix
{ pkgs, ergo, ... }: {
  home.packages = [
    pkgs.wmenu
    # gcc provides cc, which rustc links with; macOS gets it from the Xcode CLT
    pkgs.gcc
    # mac-1 uses the native macOS app from the telegram cask instead
    pkgs.telegram-desktop
    # status bar, spawned by name from niri/config.kdl
    ergo.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # no display manager: start niri when logging in on tty1, other ttys stay plain shells
  programs.fish.loginShellInit = ''
    if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
      exec niri-session
    end
  '';

  # writes gtk3/4 prefer-dark and dconf color-scheme, which the portal hands to chromium/electron
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  # based on upstream's default-config.kdl; niri ignores its built-in defaults once this file exists
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
}
