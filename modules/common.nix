# system config shared by every host, nix-darwin and NixOS alike
{ pkgs, self, ... }: {
  environment.systemPackages = [ pkgs.vim ];
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  fonts.packages = [ pkgs.iosevka-bin ];

  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;
}
