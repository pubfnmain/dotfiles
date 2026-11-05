# home-manager config for pc-1 only; ghostty itself comes from home/default.nix
{ pkgs, ... }: {
  home.packages = [ pkgs.wmenu ];

  # niri ignores its built-in defaults once this file exists, so start from upstream's
  # default config and swap the launchers; --replace-fail flags upstream changes on bump
  xdg.configFile."niri/config.kdl".source = pkgs.runCommand "niri-config.kdl" { } ''
    substitute ${pkgs.niri.src}/resources/default-config.kdl $out \
      --replace-fail \
        'Mod+T hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }' \
        'Mod+T hotkey-overlay-title="Open a Terminal: ghostty" { spawn "ghostty"; }' \
      --replace-fail \
        'Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }' \
        'Mod+D hotkey-overlay-title="Run an Application: wmenu" { spawn "wmenu-run"; }'
  '';
}
