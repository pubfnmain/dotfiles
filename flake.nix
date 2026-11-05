{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim }:
  let
    username = "pubfnmain";
    specialArgs = { inherit self username; };

    homeManager = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
      home-manager.users.${username} = import ./home;
    };
  in
  {
    darwinConfigurations."mac-1" = nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        ./modules/common.nix
        ./hosts/mac-1
        home-manager.darwinModules.home-manager
        homeManager
      ];
    };
  };
}
