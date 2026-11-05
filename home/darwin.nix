{ lib, pkgs, ... }: {
  # enables BSD ls colors, its default LSCOLORS is ANSI so it follows the Ghostty theme
  home.sessionVariables.CLICOLOR = "1";

  programs.ghostty = {
    # pkgs.ghostty is Linux-only
    package = pkgs.ghostty-bin;
    # nix owns the version, stop Sparkle updating the app
    settings.auto-update = "off";
  };

  # mkAfter keeps this after the shared paths, matching append order
  programs.fish.shellInit = lib.mkAfter ''
    fish_add_path -Pa "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  '';
}
