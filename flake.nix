{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    common = { };
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.common.inputs.nixos-flake.flakeModule ];

      flake = {
        # Configurations for macOS machines
        nixosConfigurations.idli = self.nixos-flake.lib.mkLinuxSystem {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            inputs.common.nixosModules.default
            self.nixosModules.home-manager
            ./configuration.nix
          ];
          nixos-flake = {
            sshTarget = "nix-infra@idli";
            overrideInputs = [ "common" ];
          };
        };
      };
    };
}
