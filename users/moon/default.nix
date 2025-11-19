{
  pkgs,
  config,
  lib,
  ...
}:
{
  users.users.moon = {
    isNormalUser = true;
    description = "moon";
    extraGroups = [
      "networkmanager"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.moon = import ./home.nix;
  };
}
