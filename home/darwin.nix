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
  # nixpkgs chromium is Linux-only, the app comes from the ungoogled-chromium brew cask
  programs.chromium.package = null;

  programs.fish.shellInit = lib.mkAfter ''
    fish_add_path -Pa "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  '';
}
