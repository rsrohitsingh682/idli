{ flake, ... }:
{
  imports = [
    flake.inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  networking.hostName = "idli";
  boot.loader.grub = {
    # adding devices is managed by disko
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  system.stateVersion = "23.11";
}
