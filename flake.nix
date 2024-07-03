{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, disko, ... }:
    let
      # TODO: Adjust these values to your needs
      system = "x86_64-linux";
      hostName = "idli";
      rootAuthorizedKeys = [
        # This user can ssh using `ssh root@<ip>`
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfoDIvV2Wm5MaOSH+AcfO8k2BpXIsBVgtNXHBB6USu8p/nk3OqF+gvtuHQZQbFzRROBVInFdkNz9pEbNehNG/128b0sGPfV9CvN6rbAQLoz4pT8qalB/UQkM9XlKqhh/ltL0SvGT/+n7SfV+HsFodgmqW4u801Wxyg4B2OSzmyhVApRP/ySLEzbKPySJDLCxlL55D6FJYcltY0jSF/8c88zd4kFEWeg71tZhf1nYiUJn5Gl7dA5K5V8wScfrqedZC6qVX6LRRKziBqCLi7DehZOooZaB5vDfMUylJpIP44Rxb0LkLLvcxRvNqQzVKGn2ubu++7FEOHGAy8qpNtd/AXPJEWW4Y+Pw1qQIQlVa6jVCI3/VCgsLSNL2mfh1J1HvYrsQ0p6oOEREIQ4tNOfPlUj5vJvHRBaNXW7m3v/K8Il93C+QjvIGxqYC4S1u4wAEVewbfysbi8rWx1y0EOElkr4e/zMOcqOh8YSuW6iVhUJDgcG1YdBFbe2yPyxm8G7hU= rohit.singh@rohit.singh-MacBookPro"

      ];
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./disk-config.nix
          disko.nixosModules.disko
          ({ pkgs, ... }: {
            boot.loader = {
              systemd-boot.enable = true;
              efi.canTouchEfiVariables = true;
            };
            networking = { inherit hostName; };
            services.openssh.enable = true;
            environment.systemPackages = with pkgs; [
              htop
              git
              neovim
            ];

            users.users.root.openssh.authorizedKeys.keys = rootAuthorizedKeys;

            system.stateVersion = "23.11";
          })
        ];
      };
    };
}
