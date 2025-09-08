{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    waybar = {
      url = "github:Alexays/Waybar/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nvf,
    catppuccin,
    nixos-hardware,
    hyprland,
    hyprland-plugins,
    waybar,
    ...
  }: {
    nixosConfigurations.KINGKONG = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
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
