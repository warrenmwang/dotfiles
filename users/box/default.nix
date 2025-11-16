{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.box = {
    isNormalUser = true;
    description = "box";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.box = import ./home.nix;
  };
}
