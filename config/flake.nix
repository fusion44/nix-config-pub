{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-mgr = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    home-mgr,
    flake-utils,
  }: {
    nixosConfigurations.xps13 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix home-mgr.nixosModule];
    };
    nixosConfigurations.g750j = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix home-mgr.nixosModule];
    };
    nixosConfigurations.um700 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix home-mgr.nixosModule];
    };
  };
}
