{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";

    ergo.url = "github:pubfnmain/ergo";
    ergo.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim, ergo }:
  let
    username = "pubfnmain";
    specialArgs = { inherit self username; };

    homeManager = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      # ergo only builds for x86_64-linux, so modules get the flake and pc-1 picks the package
      home-manager.extraSpecialArgs = { inherit ergo; };
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

    nixosConfigurations."pc-1" = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        ./modules/common.nix
        ./hosts/pc-1
        home-manager.nixosModules.home-manager
        homeManager
      ];
    };
  };
}
