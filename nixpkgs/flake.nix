{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # nixpkgs-unstable,
    nvf,
    catppuccin,
    nixos-hardware,
    ...
  }: {
    nixosConfigurations.KINGKONG = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        # pkgs-unstable = import nixpkgs-unstable {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };
      modules = [
        ./hosts/KINGKONG/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.nvf.nixosModules.default
        inputs.catppuccin.nixosModules.catppuccin
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      ];
    };
  };
}
